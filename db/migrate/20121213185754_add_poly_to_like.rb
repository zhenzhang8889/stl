class AddPolyToLike < ActiveRecord::Migration
  def change
    add_column :likes, :likeable_id, :integer
    add_column :likes, :likeable_type, :string
    add_index :likes, :likeable_id
    remove_column :likes, :user_id
    remove_column :likes, :post_id
    remove_column :likes, :status_id
    remove_column :likes, :workout_id
  end
end
