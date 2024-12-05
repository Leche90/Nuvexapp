class AddTaxesToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :gst, :decimal, precision: 10, scale: 3
    add_column :orders, :pst, :decimal, precision: 10, scale: 3
    add_column :orders, :hst, :decimal, precision: 10, scale: 3
  end
end
