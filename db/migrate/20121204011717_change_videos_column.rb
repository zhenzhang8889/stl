class ChangeVideosColumn < ActiveRecord::Migration
  def up
  	remove_column :videos, :workout_id
    change_table :videos do |t|
      t.references :videoable, :polymorphic => true
    end
  end

  def down

  end
end