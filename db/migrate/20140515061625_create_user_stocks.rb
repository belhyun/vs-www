class CreateUserStocks < ActiveRecord::Migration
  def change
    create_table :user_stocks do |t|
      t.integer :user_id
      t.integer :stock_id
      t.string :issue_id
      t.references :user, index: true
      t.references :issue, index: true

      t.timestamps
    end
  end
end
