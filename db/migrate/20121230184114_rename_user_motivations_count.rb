class RenameUserMotivationsCount < ActiveRecord::Migration
  def up
  	rename_column :users, :motivations_count, :compliments_count
  end

  def down
  end
end
