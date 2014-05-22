class CreateLogUserStocks < ActiveRecord::Migration
  def change
    create_table :log_user_stocks do |t|
      t.integer :type
      t.integer :stock_amounts
      t.references :user, index: true
      t.references :stock, index: true
      t.references :issue, index: true
      t.integer :user_money
      t.integer :day

      t.timestamps
    end
  end
end
