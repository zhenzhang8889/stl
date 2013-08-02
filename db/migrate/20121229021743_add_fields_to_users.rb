class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :experience, :text
    add_column :users, :location, :string
    add_column :users, :website, :string
    add_column :users, :tagline, :string
  end
end
