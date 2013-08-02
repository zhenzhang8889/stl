class ChangeMicroposts < ActiveRecord::Migration
  def up
  	change_table :microposts do |t|
  t.remove :content
  t.text :content
 
  end
end


  def down
  end
end
