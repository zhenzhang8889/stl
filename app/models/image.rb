# == Schema Information
#
# Table name: images
#
#  id                :integer         not null, primary key
#  item_file_name    :string(255)
#  item_content_type :string(255)
#  item_file_size    :integer
#  item_updated_at   :datetime
#  imageable_id      :integer
#  imageable_type    :string(255)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

class Image < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  attr_accessible :item

  has_attached_file :item, 
    :styles => { :medium => "250x250>", :thumb => "100x100>", :show => "770X770>", :related => "x80", :stack => "320" },
    :path => "/images/:content_class/:style/:id.:extension"

  validates_attachment :item, 
    :content_type => { :content_type => ["image/jpeg","image/png","image/gif"] }


  Paperclip.interpolates :content_class do |attachment, style|
    attachment.instance.content_class_name
  end

	def content_class_name
	  "#{self.imageable.class.table_name.singularize.downcase}"
	end
end
