class CreateCompliments < ActiveRecord::Migration
  def change
    create_table :compliments do |t|
      t.references :user
      t.integer :motivator_id
      t.text :message

      t.timestamps
    end
    add_index :compliments, :user_id
  end
end
