class AddMotivationsCountToUser < ActiveRecord::Migration
  def change
  	add_column :users, :motivations_count, :integer, :default => 0, :null => false
  end
end
