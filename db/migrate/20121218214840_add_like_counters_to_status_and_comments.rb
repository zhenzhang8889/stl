class AddLikeCountersToStatusAndComments < ActiveRecord::Migration
  def change
  	add_column :posts, :likes_count, :integer, :default => 0, :null => false
    add_column :workouts, :likes_count, :integer, :default => 0, :null => false
    add_column :statuses, :likes_count, :integer, :default => 0, :null => false
    add_column :comments, :likes_count, :integer, :default => 0, :null => false
  end
end
