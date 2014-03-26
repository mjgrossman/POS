class UpdatePrice < ActiveRecord::Migration
  def change
    change_column :products, :price, :decimal, :precision => 7, :scale => 2
  end
end
