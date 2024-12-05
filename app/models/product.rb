class Product < ApplicationRecord
  has_one_attached :image
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :order_items
  has_many :product_pricing_histories

  scope :new_products, -> { where("created_at >= ?", 3.days.ago).order(created_at: :desc) }
  scope :recently_updated, -> { where("updated_at >= ?", 3.days.ago).order(updated_at: :desc) }

  # Remove the below line since a product can have many categories
  # belongs_to :category

  # Search method
  def self.search_by_keyword_and_category(keyword, category_id = nil)
    products = where("name LIKE ? OR description LIKE ?", "%#{keyword}%", "%#{keyword}%")
    products = products.where(category_id: category_id) if category_id.present?
    products
  end

  validates :name, presence: true
  validates :description, presence: false
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :image, presence: true
end
