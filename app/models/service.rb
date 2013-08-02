class Service < ActiveRecord::Base
  include Haveable, Belongable, Taggable, Feedable, Shareable, General, Stackable
  
  attr_accessible :name, :description, :tag_list, 
                  :videos_attributes, :images_attributes,
                  :likes_count, :shares, :share_list,:comments_count,
                  :price, :spots, :location, :expiration_date, :promotion
                  
  accepts_nested_attributes_for :videos
  accepts_nested_attributes_for :images
  
  attr_accessor :promotion  
  
  validates :name,  presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :price, presence: true
  validates :expiration_date, presence: true
  validates :spots, presence: true
  
  validates_presence_of :user_id
  
  def has_videos?
    videos.present?
  end

  def has_images?
    images.present?
  end
  
  def append_to_method
    feeds.first.id
  end              
  
  def related_content
    Service.tagged_with(self.tag_list, :on => :tags, :any => true).where("user_id != ?", self.user_id)
  end
end
