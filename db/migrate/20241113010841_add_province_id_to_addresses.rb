class AddProvinceIdToAddresses < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:addresses, :province_id)
      add_reference :addresses, :province, null: false, foreign_key: true
    end
  end
end
