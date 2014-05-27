class CreateLogStocks < ActiveRecord::Migration
  def change
    create_table :log_stocks do |t|
      t.integer :stock_id
      t.integer :stock_buying
      t.string :stock_selling_integer
      t.integer :stock_money
      t.references :stock, index: true

      t.timestamps
    end
  end
end
