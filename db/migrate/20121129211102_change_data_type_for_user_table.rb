class ChangeDataTypeForUserTable < ActiveRecord::Migration
  def change
  	change_table :users do |t|
  	t.change :interests, :string
  	t.change :goals, :string
end
  end
end


