class RemoveStoryFromNotifications < ActiveRecord::Migration
  def up
  	remove_column :notifications, :story
  end

  def down
  end
end
