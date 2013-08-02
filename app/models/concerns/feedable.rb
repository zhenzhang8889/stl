module Feedable
  extend ActiveSupport::Concern

  included do
    after_create :generate_feed_item
  end

  def generate_feed_item
    feeds.create do |feed|
      feed.user_id = user.id
      feed.tag_list = tag_list
    end
  end
end
