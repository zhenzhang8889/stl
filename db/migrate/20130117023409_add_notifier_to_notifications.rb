class AddNotifierToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :notifier_id, :integer
  end
end
