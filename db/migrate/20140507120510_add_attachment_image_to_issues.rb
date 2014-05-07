class AddAttachmentImageToIssues < ActiveRecord::Migration
  def self.up
    change_table :issues do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :issues, :image
  end
end
