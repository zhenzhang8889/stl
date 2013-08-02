class CreateServices < ActiveRecord::Migration
  def change
     create_table :services do |t|
      t.string    "name"
      t.text      "description"
      t.string    "location"
      
      t.integer   "user_id"
      t.string    "price"
      t.integer   "spots"
      t.date      "expiration_date"
      t.string    "shares"
      t.integer   "likes_count",    :default => 0, :null => false
      t.integer   "comments_count", :default => 0, :null => false
      t.timestamps    
    end
  end
  
  def self.down
    drop_table :services
  end
end
