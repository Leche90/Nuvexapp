class AddOrderIdToAddresses < ActiveRecord::Migration[7.2]
  def change
    add_column :addresses, :order_id, :bigint
  end
end
