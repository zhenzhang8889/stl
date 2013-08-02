class CreateThankings < ActiveRecord::Migration
  def change
    create_table :thankings do |t|
      t.references :user
      t.integer :thanker_id
      t.text :resource

      t.timestamps
    end
    add_index :thankings, :user_id
    add_index :thankings, :thanker_id
  end
end
