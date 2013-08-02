class Compliment < ActiveRecord::Base
  CANNED_MESSAGES = ["Thank you.", "Keep it up!", "Wow, you're fit.", "You're an inspiration!"]
  
  attr_accessible :message, :motivator_id, :canned_message, :custom_message

  validates_presence_of :motivator_id, :user_id

  belongs_to :user, :counter_cache => true
  has_many :notifications, as: :notifiable

  attr_accessor :canned_message, :custom_message

  validate :check_message_present
  validate :check_message_length
  before_save :save_message

  def motivator
  	User.find(motivator_id)
  end

  def check_message_length
    if @custom_message.present? && @custom_message.length > 160
      errors.add :message, "Must be less than 160 characters"
    end
  end

  def check_message_present
  	if messages_are_nil?
  		errors.add :message, "Must be present"
  	end
  end

  def messages_are_nil?
    @custom_message.blank? && @canned_message.blank?
  end

  def save_message
    if @custom_message.present?
      self.message = @custom_message
    else
      self.message = @canned_message
    end
  end
end