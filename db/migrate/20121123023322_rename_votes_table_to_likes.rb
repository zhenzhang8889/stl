class RenameVotesTableToLikes < ActiveRecord::Migration
  def up
    rename_table :votes,:likes
    add_column   :likes,:status_id,:integer
    add_column   :likes,:workout_id,:integer
  end

  def down
    remove_column :likes,:workout_id
    remove_column :likes,:status_id
    rename_table :likes,:votes
   end
end
