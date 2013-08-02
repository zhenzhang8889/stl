class AddYouTubeToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :youtube, :string
  end
end
