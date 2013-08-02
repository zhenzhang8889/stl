class AddSharedToContentModels < ActiveRecord::Migration
  def change
  	add_column :statuses, :shares, :string
  	add_column :workouts, :shares, :string
  	add_column :posts, :shares, :string
  end
end
