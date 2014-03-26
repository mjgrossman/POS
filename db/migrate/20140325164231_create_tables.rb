class CreateTables < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price

      t.timestamps
    end

    create_table :transactions do |t|
      t.integer :cashier_id

      t.timestamps
    end

    create_table :cashiers do |t|
      t.string :name

      t.timestamps
    end

    create_table :returns do |t|
      t.integer :product_id
      t.integer :quantity
      t.integer :transaction_id
      t.integer :cashier_id

      t.timestamps
    end

    create_table :quantities do |t|
      t.integer :product_id
      t.integer :transaction_id
      t.integer :quantity

      t.timestamps
    end

  end
end
