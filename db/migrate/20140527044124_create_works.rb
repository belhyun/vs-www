class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :title
      t.string :description
      t.integer :give_money
      t.date :end_date

      t.timestamps
    end
  end
end
