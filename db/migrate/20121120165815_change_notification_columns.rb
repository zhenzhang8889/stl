class ChangeNotificationColumns < ActiveRecord::Migration
  def up
  	change_table :notifications do |t|
	  t.remove :notification_type
	  t.rename :resource_type, :resource
	end
  end

  def down
  end
end
