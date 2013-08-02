# == Schema Information
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  content          :text
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  likes_count      :integer         default(0), not null
#

class Comment < ActiveRecord::Base
  attr_accessible :content, :commentable_id, :commentable_type, :likes_count

  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :user
  has_many :likes, as: :likeable
  has_many :notifications, as: :notifiable
  
  validates_presence_of :content
end
