class AddLikesCountToStacks < ActiveRecord::Migration
  def change
    add_column :stacks, :likes_count, :integer
  end
end
