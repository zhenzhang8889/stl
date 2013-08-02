class CreateStackedItems < ActiveRecord::Migration
  def change
    create_table :stacked_items do |t|
      t.integer :stackable_id
      t.string :stackable_type
      t.integer :stack_id

      t.timestamps
    end
  end
end
