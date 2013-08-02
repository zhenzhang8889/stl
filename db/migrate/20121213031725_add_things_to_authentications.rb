class AddThingsToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :refresh_token, :string
    add_column :authentications, :token_expires_at, :string
  end
end
