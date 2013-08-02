class RenameMicropostsToStatuses < ActiveRecord::Migration
  def up
    rename_table :microposts,:statuses
  end

  def down
    rename_table :statuses,:microposts
  end
end
