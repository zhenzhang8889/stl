class Stack < ActiveRecord::Base
  include General, Shareable
  
  attr_accessible :description, :name, :likes_count, :stacked_items_attributes, 
                  :comments_count, :image_attributes, :shares

  belongs_to :user
  has_many :stacked_items, dependent: :destroy
  has_many :likes, dependent: :destroy, as: :likeable
  has_many :comments, dependent: :destroy, as: :commentable
  has_many :notifications, as: :notifiable
  has_one :image, as: :imageable

  accepts_nested_attributes_for :stacked_items
  accepts_nested_attributes_for :image

  acts_as_followable
  acts_as_taggable_on :shares

  validates_presence_of :name

  def append_to_method
    id
  end

  def add_stacked_item_for(content)
    self.stacked_items.create!(
      stackable_id: content.id,
      stackable_type: content.type_name
      )
  end

  def content_image
    with_images = stacked_items.select { |i| i if i.stackable.images.present? }
    if with_images.count > 0
      with_images.first.stackable.images.first
    else
      false
    end
  end
end


