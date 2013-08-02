class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.references :user
      t.references :feedable, :polymorphic => true

      t.timestamps
    end
    add_index :feeds, :user_id
    add_index :feeds, :feedable_id
  end
end
