class CreateProvinces < ActiveRecord::Migration[7.2]
  def change
    create_table :provinces do |t|
      t.string :name, null: false
      t.string :code, null: false

      t.timestamps
    end
  end
end
