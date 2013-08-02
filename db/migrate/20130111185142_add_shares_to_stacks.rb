class AddSharesToStacks < ActiveRecord::Migration
  def change
    add_column :stacks, :shares, :string
  end
end
