class AddWorkoutIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :workout_id, :integer
    add_index :videos, :workout_id
  end
end
