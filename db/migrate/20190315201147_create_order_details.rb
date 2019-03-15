class CreateOrderDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :order_details do |t|
      t.string :person
      t.integer :order_id
      t.integer :variety_id
      t.integer :quantity
      t.timestamps
    end
  end
end
