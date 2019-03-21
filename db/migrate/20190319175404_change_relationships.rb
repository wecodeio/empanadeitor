class ChangeRelationships < ActiveRecord::Migration[5.2]
  def change
    remove_column :order_details, :variety_id
    remove_column :orders, :place_id
    add_column :orders, :place_name, :string
    add_column :orders, :place_address, :string
    add_column :orders, :place_phone, :string
    add_column :order_details, :variety_name, :string
  end
end
