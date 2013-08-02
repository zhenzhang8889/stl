class AddPolyToComment < ActiveRecord::Migration
  def change
    add_column :comments, :commentable_id, :integer
    add_index :comments, :commentable_id
    add_column :comments, :commentable_type, :string
    add_column :comments, :user_id, :integer
    add_index :comments, :user_id
    remove_column :comments, :post_id
    remove_column :comments, :status_id
    remove_column :comments, :workout_id
  end
end
