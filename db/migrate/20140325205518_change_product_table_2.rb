class ChangeProductTable2 < ActiveRecord::Migration
  def change
    remove_column :products, :price
  end
end

