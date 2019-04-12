class AddOpenIntoOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :open, :boolean
  end
end
