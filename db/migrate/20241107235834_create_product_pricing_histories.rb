class CreateProductPricingHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :product_pricing_histories do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :price
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
