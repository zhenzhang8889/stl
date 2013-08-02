class AddBehaviourToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :behaviour, :string
  end
end
