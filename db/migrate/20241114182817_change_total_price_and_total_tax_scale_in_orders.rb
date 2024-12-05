class ChangeTotalPriceAndTotalTaxScaleInOrders < ActiveRecord::Migration[7.2]
  def change
    change_column :orders, :total_price, :decimal, precision: 10, scale: 3
    change_column :orders, :total_tax, :decimal, precision: 10, scale: 3
  end
end
