# == Schema Information
#
# Table name: feeds
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  feedable_id   :integer
#  feedable_type :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class Feed < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :user, counter_cache: true
  belongs_to :feedable, :polymorphic => true

  acts_as_taggable


  def self.from_users_followed_by(user, options={})
    case options[:type]
    when "profile"
      where(:user_id => user.id)
    when "tags"
      followed_user_ids = "SELECT followed_id FROM relationships
                           WHERE follower_id = :user_id"
      where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id).tagged_with(options[:tag])
    when "search"
      where(:id => Feed.all.map(&:id))
    else
      followed_user_ids = "SELECT followed_id FROM relationships
                           WHERE follower_id = :user_id"
      where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
      		user_id: user.id)
    end
  end

  def self.filter_content_type(types)
    where(:feedable_type => types)
  end

  def self.discover_content(type, user)
    case type
    when "recommended"
      Feed.get_reco_for(user).order("created_at DESC")
    when "popular"
      Feed.all.sort_by { |f| f.feedable.likes_count }.reverse
    when "featured"
      Feed.all
    end
  end

  # REFACTOR: wow
  def self.get_reco_for(user)
    statuses = Array.new
    posts = Array.new
    workouts = Array.new
    [:status, :post, :workout].each do |content|
      klass = content.to_s.capitalize.constantize
      array = content.to_s.pluralize
      klass.all.each do |klass|
        klass.tag_list.each do |tag|
          user.interest_list.each do |i|
            eval(array).push(klass.id) if tag.downcase == i.downcase
          end
        end
      end
    end
    status_feed = Feed.where(feedable_id: statuses, feedable_type: "Status")
    post_feed = Feed.where(feedable_id: posts, feedable_type: "Post")
    workout_feed = Feed.where(feedable_id: workouts, feedable_type: "Workout")
    final_feeds = status_feed + post_feed + workout_feed
    Feed.where(:id => final_feeds.map(&:id))
  end
  
  def self.search_posts(keyword)
    where("feedable_id IN (SELECT id FROM posts WHERE name like '%#{keyword}%' OR body like '%#{keyword}%') AND feedable_type = 'Post'")
  end
  
  def self.search_statuses(keyword)
    where("feedable_id IN (SELECT id FROM statuses WHERE content LIKE '%#{keyword}%') AND feedable_type = 'Status'")
  end
  
  def self.search_workouts(keyword)
    where("feedable_id IN (SELECT id FROM workouts WHERE name LIKE '%#{keyword}%' OR description LIKE '%#{keyword}%') AND feedable_type = 'Workout'")
  end
  
  def is_a_workout?
  	feedable_type == "Workout"
  end

  def is_a_status?
  	feedable_type == "Status"
  end

  def is_a_post?
  	feedable_type == "Post"
  end

  def is_a_service?
    feedable_type == "Service"
  end

end
