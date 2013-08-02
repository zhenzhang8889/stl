class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :name
      t.integer :reps
      t.float :weight
      t.string :equipment
      t.text :description
      t.attachment :image
      t.attachment :video
      t.references :workout

      t.timestamps
    end
    add_index :exercises, :workout_id
  end
end
