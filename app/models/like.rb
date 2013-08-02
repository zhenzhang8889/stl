# == Schema Information
#
# Table name: likes
#
#  id            :integer         not null, primary key
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  likeable_id   :integer
#  likeable_type :string(255)
#  user_id       :integer
#

class Like < ActiveRecord::Base
  attr_accessible :likeable_id, :likeable_type, :user_id
  belongs_to :likeable, polymorphic: true, :counter_cache => true
  belongs_to :user
  has_many :notifications, as: :notifiable
end
