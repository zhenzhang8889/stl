class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name
      t.string :link
      t.text :body

      t.timestamps
    end
  end
end
