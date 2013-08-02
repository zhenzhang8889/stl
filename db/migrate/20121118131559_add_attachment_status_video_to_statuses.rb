class AddAttachmentStatusVideoToStatuses < ActiveRecord::Migration
  def self.up
    change_table :statuses do |t|
      t.has_attached_file :status_video
    end
  end

  def self.down
    drop_attached_file :statuses, :status_video
  end
end
