class CreateLogUsers < ActiveRecord::Migration
  def change
    create_table :log_users do |t|
      t.integer :user_id
      t.integer :user_money
      t.references :user, index: true

      t.timestamps
    end
  end
end
