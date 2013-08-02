class ChangeMotivationsMessageColumn < ActiveRecord::Migration
  def up
  	change_column :motivations, :message, :string
  end

  def down
  	change_column :motivations, :message, :text
  end
end
