class AddViewedToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :viewed, :boolean
    add_index :notifications, :viewed
  end
end
