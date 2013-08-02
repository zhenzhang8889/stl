# == Schema Information
#
# Table name: exercises
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  reps               :integer
#  weight             :float
#  equipment          :string(255)
#  description        :text
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  video_file_name    :string(255)
#  video_content_type :string(255)
#  video_file_size    :integer
#  video_updated_at   :datetime
#  workout_id         :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

class Exercise < ActiveRecord::Base
	belongs_to :workout
  
  scope :by_keyword,  lambda{ | keyword | where("name Like ? OR description LIKE ? ", "%#{keyword}%", "%#{keyword}%") }
  
	attr_accessible :description, :equipment, :image, :name, :reps, :video, :weight, :image

	validates_presence_of :name, :reps

	validates_numericality_of :reps
	has_many :videos, as: :videoable

	has_attached_file :image, 
    :styles => { :medium => "300x300>", :thumb => "100x100>" },
    :path => "/images/:class/:id/:style.:extension"

  validates_attachment :image, 
    :content_type => { :content_type => ["image/jpeg","image/png","image/gif"] }

  has_attached_file :video, 
    :path => "/images/:class/:id/:style.:extension"

  validates_attachment :video, 
      :content_type => { :content_type => ["video/quicktime", "video/mov", "video/avi", "video/wmv"] }

	Paperclip.interpolates :normalized_file_name do |attachment, style|
		attachment.instance.normalized_file_name
	end                 

	def normalized_file_name
	  "#{self.id}#{self.image_file_name.gsub(/[^a-zA-Z0-9_\.]/, '_')}"
	end
end
