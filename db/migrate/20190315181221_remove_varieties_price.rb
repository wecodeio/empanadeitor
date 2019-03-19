class RemoveVarietiesPrice < ActiveRecord::Migration[5.2]
  def change
    remove_column :varieties, :price
  end
end
