# == Schema Information
#
# Table name: videos
#
#  id             :integer         not null, primary key
#  title          :string(255)
#  panda_video_id :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  videoable_id   :integer
#  videoable_type :string(255)
#

class Video < ActiveRecord::Base
  default_scope where("panda_video_id <> '' OR youtube <> ''")
  
  attr_accessible :panda_video_id, :title, :youtube
  belongs_to :videoable, polymorphic: true

  before_save :set_youtube_id, :if => :has_youtube?

  def panda_video
    @panda_video ||= Panda::Video.find(panda_video_id)
  end

  def h264_encoding
  	panda_video.encodings["h264"]
  end

  def ready_to_view?
  	panda_video.status == "success" && h264_encoding.encoding_progress == 100
  end

  def has_youtube?
    !youtube.blank?
  end

  def set_youtube_id
    regex = /https?:\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\S)*/
    youtube.gsub(regex) do
      self.youtube = $3
    end
  end
end
