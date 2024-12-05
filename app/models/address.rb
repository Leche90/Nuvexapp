class Address < ApplicationRecord
  belongs_to :user
  belongs_to :province
  belongs_to :order, optional: true

  validates :address_line1, :city, :postal_code, :country, presence: true
  validates :province_id, presence: true
end
