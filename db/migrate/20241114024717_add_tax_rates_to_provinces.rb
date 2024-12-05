class AddTaxRatesToProvinces < ActiveRecord::Migration[7.2]
  def change
    add_column :provinces, :pst, :decimal, precision: 5, scale: 4, default: 0
    add_column :provinces, :gst, :decimal, precision: 5, scale: 4, default: 0
    add_column :provinces, :hst, :decimal, precision: 5, scale: 4, default: 0
  end
end
