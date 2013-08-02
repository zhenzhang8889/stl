# == Schema Information
#
# Table name: workouts
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  description    :text
#  user_id        :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  comments_count :integer         default(0), not null
#  likes_count    :integer         default(0), not null
#


class Workout < ActiveRecord::Base
  include Haveable, Belongable, Taggable, Feedable, Shareable, General, Stackable

  attr_accessible :name, :description, :tag_list,:exercises_attributes, 
                  :videos_attributes, :images_attributes, :comments_count,
                  :likes_count, :shares, :share_list

  has_many :exercises, dependent: :destroy

  accepts_nested_attributes_for :exercises, allow_destroy: true
  accepts_nested_attributes_for :videos
  accepts_nested_attributes_for :images

  validates :name,  presence: true
  validates :description, presence: true
  validates_presence_of :user_id
  
  scope :by_keyword,  lambda{ | keyword | where("name Like ? OR description LIKE ? ", "%#{keyword}%", "%#{keyword}%") }
  def append_to_method
    feeds.first.id
  end

  def related_content
    Workout.tagged_with(self.tag_list, :on => :tags, :any => true).where("user_id != ?", self.user_id)
  end

  def has_videos?
    videos.present?
  end

  def has_images?
    images.present?
  end

  def feedable_title
    name
  end

  def feedable_desc
    description
  end

  def css_name
    "workout"
  end
end

