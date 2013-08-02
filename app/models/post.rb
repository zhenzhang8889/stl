# == Schema Information
#
# Table name: posts
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  link           :string(255)
#  body           :text
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  user_id        :integer
#  comments_count :integer         default(0), not null
#  likes_count    :integer         default(0), not null
#


class Post < ActiveRecord::Base
  include Haveable, Belongable, Taggable, Feedable, Shareable, General, Stackable

  attr_accessible :body, :link, :name, :tag_list,:videos_attributes,
                  :images_attributes, :comments_count, :likes_count, 
                  :shares, :share_list

  validates_presence_of :body,:name

  accepts_nested_attributes_for :videos
  accepts_nested_attributes_for :images
  
  # search for goal keyword on the homepage
  scope :by_keyword, lambda { |keyword| where('name LIKE ? OR body LIKE ?', "%#{keyword}%", "%#{keyword}%" )}
     
  # REFACTOR: come rails for, use "where.not"
  def related_content
    Post.tagged_with(self.tag_list, :on => :tags, :any => true).where("user_id != ?", self.user_id)
  end

  def append_to_method
    feeds.first.id
  end

  def to_param
	 "#{id}-#{name.gsub(/\W/, '-').downcase}"
	end

  def css_name
    "blog_post"
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
    body
  end
end
