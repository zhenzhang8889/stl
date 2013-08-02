class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|

    t.column :user_id, :integer
      t.timestamps
    end
  end
end
