class AddFbImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :social_image, :string
  end
end
