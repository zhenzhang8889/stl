class AddFeedsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :feeds_count, :integer, :default => 0, :null => false
  end
end
