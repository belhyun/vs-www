class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.integer :major
      t.integer :minor
      t.timestamps
    end
  end
end
