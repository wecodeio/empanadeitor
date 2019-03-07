class CreateVarieties < ActiveRecord::Migration[5.2]
  def change
    create_table :varieties do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2, default: 0.0
      t.integer :place_id
      t.timestamps
    end
  end
end
