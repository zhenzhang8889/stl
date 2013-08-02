class AddAuthPresentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_present, :boolean
  end
end
