class AddPlaceIdIntoOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :place_id, :integer
  end
end
