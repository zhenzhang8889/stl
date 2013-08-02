class AddContentToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :gender, :integer
  	add_column :users, :interests, :text
  	add_column :users, :bio, :text
  	add_column :users, :goals, :text 
  	add_column :users, :name, :string
  end
end
