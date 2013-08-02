class AddStoryToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :story, :integer
  end
end
