# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  username               :string(255)
#  gender                 :integer
#  interests              :string(255)
#  bio                    :text
#  goals                  :string(255)
#  name                   :string(255)
#  compliments_count      :integer         default(0), not null
#  thankings_count        :integer         default(0), not null
#  feeds_count            :integer         default(0), not null
#  social_image           :string(255)
#  auth_present           :boolean
#  skills                 :string
#  location               :string(255)
#  website                :string(255)
#  tagline                :string(255)
#

class User < ActiveRecord::Base
  ActsAsTaggableOn.force_lowercase = true
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  
  # Setup accessible (or protected) attributes for your model
   attr_accessible :username, :email, :password, 
      :remember_me, :login, :gender, :name, :interests, :bio, :goals, :provider, :uid,
      :compliments_count, :feeds_count, :social_image, :images_attributes, :auth_present,
      :current_password, :skill, :location, :website, :tagline, :request_city, :request_country,
      :interest_list, :skill_list, :following_count, :followers_count

  attr_accessor :login, :current_password, :request_city, :request_country
  has_private_messages
   
  GENDERS = {
    :male => 1,
    :female => 2
  }
 
  
  INTERESTS = %w(
    Weight-loss Nutrition Motivation Toning Rehabilitation 
    Power-lifting Running Bulking Sports\ Training Cross-fit 
    Strength General\ Health
  )

  NETWORK_FILTER = %w(
    Bodybuilding Cardio Cross-fit Endurance Health 
    Weight-loss Motivation Nutrition Power-lifting 
    Recovery Running Strength Supplements
  )
  
  scope :top_followed, select("users.id, count(followers.id) AS followers_count").joins(:followers).order("followers_count DESC").limit(5)

  #has_one :spec, dependent: :destroy
  has_one :goal
  has_and_belongs_to_many :events
  has_and_belongs_to_many :groups
  has_many :posts, dependent: :destroy
  has_many :workouts, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :compliments
  has_many :notifications
  has_many :likes,dependent: :destroy
  has_many :thankings, :foreign_key => :thanker_id
  has_many :thanks, :class_name => Thanking, :foreign_key => :user_id
  has_many :images, :as => :imageable
  has_many :authentications
  has_many :comments
  has_many :stacks
  has_many :notifications

  accepts_nested_attributes_for :images

  acts_as_taggable_on :interests, :skills

  acts_as_follower

  before_save :set_location, if: :location_present?

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX }
  validates :username, presence: true, uniqueness: true

	def self.find_first_by_auth_conditions(warden_conditions)
	  conditions = warden_conditions.dup
	  if login = conditions.delete(:login)
	    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
	  else
	    where(conditions).first
	  end
	end

  def attach_social( auth )
    self.authentications.create!(:provider => auth[:provider],
      :uid => auth[:uid],
      :token => auth[:credentials][:token],
      :token_secret => auth[:credentials][:secret],
      :refresh_token => auth[:credentials][:refresh_token],
      :token_expires_at => auth[:credentials][:token_expires_at],
      :image => auth[:info][:image]
  )
    self.update_attribute(:auth_present, true)
  end

  def self.from_omniauth(auth)
    user = where(:email => auth[:info][:email]).first_or_create do |user|
      user.username = auth[:info][:nickname]
      user.email = auth[:info][:email]
      user.name = auth[:info][:name]
      user.social_image = auth[:info][:image]
      user.location = auth[:info][:location]
      user.auth_present = true
    end
  end

  def update_with_password(params={}) 
  if params[:password].blank? 
    params.delete(:password) 
    params.delete(:password_confirmation) if params[:password_confirmation].blank? 
  end 
  update_attributes(params) 
end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      session = session["devise.user_attributes"].delete_if { |k,v| v.blank? }
      new(session, without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def set_location
    city = request_city
    country = request_country
    unless city.blank?
      self.location = "#{city} #{country}"
    else
      self.location = country
    end
  end

  def self.share_content(handles, content)
    handles.each do |h|
      begin
        # find by email or username
        h.downcase!
        u = User.find_by_email(h) || User.find_by_username!(h)

        # notify!
        Notification.delay.create_and_delegate(content.user, content, u, :share, [:site, :email])
      rescue
        # no user by username or email
        # should we just email, if email?
      end
    end
  end

  def location_present?
    !request_country.blank?
  end

  def password_required?
    !auth_present? && super
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def has_auth?(provider)
    authentications.where(:provider => provider.to_s).present?
  end

  def auth(provider)
    authentications.where(:provider => provider.to_s).first
  end

  def feed
    Status.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def find_like_for(content)
    likes.where(  :likeable_id => content.id, 
                  :likeable_type => content.class.table_name.singularize.capitalize
                ).first
  end

  def owns(object)
    object.user == self
  end

  def already_likes_this?(content)
    find_like_for(content).present?
  end

  def thanked_for_this(content)
    thankings.where(:user_id => content.user_id, 
                    :resource_id => content.id, 
                    :resource_class => content.class.table_name.singularize.to_sym).present?
  end


  def to_param
    username
  end

end
