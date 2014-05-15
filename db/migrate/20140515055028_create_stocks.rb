class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :name
      t.text :description
      t.integer :money
      t.references :issue, index: true

      t.timestamps
    end
  end
end
