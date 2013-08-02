class ChangeExperienceToSkills < ActiveRecord::Migration
  def up
  	remove_column :users, :experience
  	add_column :users, :skills, :string
  end

  def down
  end
end
