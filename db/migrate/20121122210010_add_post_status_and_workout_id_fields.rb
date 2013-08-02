class AddPostStatusAndWorkoutIdFields < ActiveRecord::Migration
  def up
    add_column :comments,:post_id,:integer
    add_column :comments,:workout_id,:integer
    add_column :comments,:status_id,:integer
  end

  def down
    remove_column :comments,:status_id
    remove_column :comments,:workout_id
    remove_column :comments,:post_id
  end
end
