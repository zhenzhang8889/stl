class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.attachment :item
      t.references :imageable, :polymorphic => true

      t.timestamps
    end
    add_index :images, :imageable_id
  end
end
