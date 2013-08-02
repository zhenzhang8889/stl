class AddThingsToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :notify_method, :string
    add_column :notifications, :notified, :boolean, default: false
    add_column :notifications, :notifiable_id, :integer
    add_index :notifications, :notifiable_id
    add_column :notifications, :notifiable_type, :string
    add_index :notifications, :notifiable_type
    remove_column :notifications, :resource
  end
end