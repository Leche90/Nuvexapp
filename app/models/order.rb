class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items
  has_one :payment
  belongs_to :address
  accepts_nested_attributes_for :address

  validates :total_price, :total_tax, presence: true
end
