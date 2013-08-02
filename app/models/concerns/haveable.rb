module Haveable
  extend ActiveSupport::Concern

  included do
    has_many :stacked_items, as: :stackable
    has_many :likes, dependent: :destroy, as: :likeable
    has_many :comments, dependent: :destroy, as: :commentable
    has_many :videos, as: :videoable
    has_many :images, as: :imageable
    has_many :feeds, as: :feedable
    has_many :notifications, as: :notifiable
  end
end
