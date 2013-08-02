class AddWorkoutUserIndex < ActiveRecord::Migration
    def change
    change_table :workouts do |t|
      t.integer :user_id
    end

 add_index :workouts, [:user_id, :created_at]
  end
end