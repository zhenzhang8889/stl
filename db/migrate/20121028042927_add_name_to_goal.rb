class AddNameToGoal < ActiveRecord::Migration
  def change
  	    change_table :goals do |t|
  	    	t.string :name
  end
end
end

