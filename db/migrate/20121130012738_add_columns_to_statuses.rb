class AddColumnsToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :attached_url_image, :string
    add_column :statuses, :attached_url, :string
    add_column :statuses, :attached_url_description, :string
    add_column :statuses, :attached_url_title, :string
  end
end
