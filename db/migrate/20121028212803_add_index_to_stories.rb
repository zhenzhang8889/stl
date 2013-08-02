class AddIndexToStories < ActiveRecord::Migration
  def change
  		add_column :posts, :user_id, :integer
  		add_column :votes, :user_id, :integer
  		add_column :groups, :user_id, :integer
  		add_column :events, :user_id, :integer
  end
end
