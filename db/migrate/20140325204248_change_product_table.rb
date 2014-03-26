class ChangeProductTable < ActiveRecord::Migration
  def change
    change_column :products, :price, :decimal, :precision => 100
  end
end
