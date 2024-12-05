class AddTotalPriceAndTotalTaxToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :total_price, :decimal
    add_column :orders, :total_tax, :decimal
  end
end
