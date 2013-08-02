class AddAttachmentWorkoutVideoToWorkouts < ActiveRecord::Migration
  def self.up
    change_table :workouts do |t|
      t.has_attached_file :workout_video
    end
  end

  def self.down
    drop_attached_file :workouts, :workout_video
  end
end
