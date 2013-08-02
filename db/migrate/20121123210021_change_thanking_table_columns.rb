class ChangeThankingTableColumns < ActiveRecord::Migration
  def up
  	change_table :thankings do |t|
	  t.remove :resource
	  t.string :resource_class
	  t.integer :resource_id
	end
  end

  def down
  end
end
