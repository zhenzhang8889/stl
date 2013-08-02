class AddUserIdToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :user_id, :integer
    add_index :likes, :user_id
  end
end
