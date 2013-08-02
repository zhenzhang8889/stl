class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :notification_type
      t.text :resource_type
      t.string :email

      t.timestamps
    end
  end
end
