class CreateNewPriceColumn < ActiveRecord::Migration
  def change
    add_column :products, :price, :decimal, :precision => 4, :scale => 2
  end
end
