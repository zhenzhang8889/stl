class AddThankingsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :thankings_count, :integer, :default => 0, :null => false
  end
end
