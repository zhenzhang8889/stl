class ChangeMotivationsToCompliments < ActiveRecord::Migration
  def up
  	create_table "compliments", :force => true do |t|
		t.integer  "user_id"
		t.integer  "motivator_id"
		t.string   "message"
		t.datetime "created_at",   :null => false
		t.datetime "updated_at",   :null => false
	end

  	add_index "compliments", ["user_id"], :name => "index_compliments_on_user_id"

  	drop_table :motivations
  end

  def down
  end
end
