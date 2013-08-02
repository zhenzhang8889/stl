class AddAttachmentPostVideoToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.has_attached_file :post_video
    end
  end

  def self.down
    drop_attached_file :posts, :post_video
  end
end
