class AddCommentsCountToStacks < ActiveRecord::Migration
  def change
    add_column :stacks, :comments_count, :integer, :default => 0, :null => false
  end
end
