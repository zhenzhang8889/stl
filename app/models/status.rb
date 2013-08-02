# == Schema Information
#
# Table name: statuses
#
#  id                       :integer         not null, primary key
#  user_id                  :integer
#  created_at               :datetime        not null
#  updated_at               :datetime        not null
#  content                  :text
#  attached_url_image       :string(255)
#  attached_url             :string(255)
#  attached_url_description :string(255)
#  attached_url_title       :string(255)
#  comments_count           :integer         default(0), not null
#  likes_count              :integer         default(0), not null
#



class Status < ActiveRecord::Base
  include Haveable, Belongable, Taggable, Feedable, Shareable, General, Stackable

  default_scope order: 'statuses.created_at DESC'

  attr_accessible :content, :tag_list, :attached_url_image, 
                  :attached_url, :attached_url_description, 
                  :attached_url_title, :videos_attributes, :images_attributes,
                  :comments_count, :likes_count, :shares, :share_list, :mini_workout_type, 
                  :mini_workout_type_custom, :duration, :duration_custom, :mini_present

  MINI_WORKOUT_OPTS = %w(crossfit running yoga sports cycling boxing weight-lifting)
  MINI_WORKOUT_DURATION_OPTS = %w(15\ min 30\ min 45\ min 1\ hr)

  attr_accessor :mini_workout_type, :mini_workout_type_custom, :duration, :duration_custom, :mini_present

  before_save :derive_mini_workout, if: :mini_workout_present?

  validates :user_id, presence: true
  validate :must_have_content, if: :mini_workout_not_present?
  validate :only_one_media_type_allowed, if: :mini_workout_not_present?
  validate :mini_parts_present, if: :mini_workout_present?

  accepts_nested_attributes_for :videos
  accepts_nested_attributes_for :images

  ### Validations

  def mini_parts_present
    if (mini_workout_type.blank? && mini_workout_type_custom.blank?) \
      && (duration.blank? && duration_custom.blank?)
      errors.add(:base, "You must supply a workout type and duration")
    end 
  end

  def must_have_content
    if content.blank? && video_form_blank? && image_form_blank? && !has_attached_link?
      errors.add(:content, "Content, Video, Image or Link must be present")
    end
  end

  def only_one_media_type_allowed
    conditions = ["video_form_blank?", "image_form_blank?", "!has_attached_link?"]
    pc = Array.new
    conditions.each do |c|
      pc.push(pc.count + 1) if eval(c) == false
    end
    errors.add(:content, "Only 1 media type is allowed (image, video, link)") if pc.count > 1
  end

  ### Class Methods

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end

  ### Instance Methods
  
  def append_to_method
    feeds.first.id
  end

  def css_name
    "status"
  end
  
  def feedable_title
    content
  end

  def feedable_desc
    false
  end

  # REFACTOR: come rails four, use "where.not"
  def related_content
    Status.tagged_with(self.tag_list, :on => :tags, :any => true).where("user_id != ?", self.user_id)
  end

  def video_form_blank?
    videos.first.youtube.blank? && videos.first.panda_video_id.blank?
  end

  def image_form_blank?
    !images.first.present?
  end

  def has_attached_link?
    if attached_url.present?
      true
    else
      false
    end
  end

  def has_attached_thumbnail?
    if attached_url.present? && attached_url_image.present?
      true
    else
      false
    end
  end

  def has_videos?
    videos.present?
  end

  def has_images?
    images.present?
  end

  ## mini workout

  def derive_mini_workout
    mini_exercise = self.mini_exercise
    mini_duration = self.mini_duration
    prefixed_exercise = self.prefixed_exercise(mini_exercise)
    sentence_start = "#{self.user.name} just worked out!"
    sentence_end = "#{self.user.name} #{prefixed_exercise} for #{mini_duration}."
    full_sentence = sentence_start + " " + sentence_end
    self.content = full_sentence
  end

  def mini_workout_present?
   mini_present == "true"
  end

  def mini_workout_not_present?
    !mini_present.present?
  end

  def mini_exercise
    if !mini_workout_type_custom.blank?
      mini_workout_type_custom
    else
      mini_workout_type
    end
  end

  def mini_duration
    if !duration_custom.blank?
      duration_custom
    else
      duration
    end
  end

  def prefixed_exercise(mini_exercise)
    if mini_exercise == mini_workout_type_custom
      mini_exercise.slice!(0..1)
      return mini_exercise
    else
      prefixes = {"crossfit" => "did crossfit", "running" => "ran", 
        "yoga" => "did yoga", "sports" => "played sports", "cycling" => "cycled", 
        "boxing" => "boxed", "weight-lifting" => "weight lifted"}

      return prefixes[mini_exercise.downcase]
    end
  end
end
