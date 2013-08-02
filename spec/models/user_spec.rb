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
#  motivations_count      :integer         default(0), not null
#  thankings_count        :integer         default(0), not null
#  feeds_count            :integer         default(0), not null
#  social_image           :string(255)
#  auth_present           :boolean
#  experience             :text
#  location               :string(255)
#  website                :string(255)
#  tagline                :string(255)
#

require 'spec_helper'

describe User do
  let(:user) { create(:user) }
  subject { user }
  it { should be_valid }

  it { should respond_to(:motivations_count) }
  it { should respond_to(:thankings_count) }
  it { should respond_to(:feeds_count) }
  it { should respond_to(:social_image) }
  it { should respond_to(:images) }
  it { should respond_to(:interests) }
  it { should respond_to(:interest_list) }
  it { should respond_to(:website) }
  it { should respond_to(:experience) }
  it { should respond_to(:location) }
  it { should allow_value("foo@bar.com").for(:email) }
  it { should_not allow_value("blah").for(:email) }
  it { should_not allow_value("a@b").for(:email) }
  it { should_not allow_value("a@.com").for(:email) }
  it { should_not allow_value("@foo.com").for(:email) }
  it { should_not allow_value(".com").for(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_presence_of(:name) }

  it { should have_one(:goal) }
  it { should have_many(:posts).dependent(:destroy) }
  it { should have_many(:workouts).dependent(:destroy) }
  it { should have_many(:statuses).dependent(:destroy) }
  it { should have_many(:followed_users).through(:relationships) }
  it { should have_many(:reverse_relationships).dependent(:destroy) }
  it { should have_many(:followers).through(:reverse_relationships) }
  it { should have_many(:motivations) }
  it { should have_many(:images) }

  describe "user authentications" do
    let(:auth) { create(:authentication) }
    let(:twitter) { { :provider => 'twitter',
                      :uid => "1234564",
                      :info => {
                        :name => "Mr. Foo Bar",
                        :nickname => "awesome",
                        :image => "http://fo.com/image.jpg"},
                      :credentials => {
                        :token => "2392834",
                        :secret => "2342328234"}
                    } 
                  }
    let(:facebook) { { :provider => 'facebook',
                       :uid => "123456",
                       :info => {
                         :email => "foo@bar.com",
                         :name => "Mr. Foo Bar",
                         :nickname => "awesome",
                         :image => "http://fo.com/image.jpg"},
                       :credentials => {
                        :token => "2392834",
                        :secret => "2342328234"}
                     }
                  }

    

    describe "#attach_social" do
      it "creates new authentication record" do
        user.attach_social(twitter)
        user.authentications.count.should eq 1
      end

      it "ensures user flag auth_present? is true" do
        user.attach_social(twitter)
        user.auth_present?.should be_true
      end
    end

    describe "#password_required?" do
      it "returns false for user with social auths" do
        user.attach_social(twitter)
        user.update_attribute(:password, nil)
        user.update_attribute(:password_confirmation, nil)
        user.password_required?.should eq false
      end

      it "returns true for regular user" do
        user.password_required?.should eq true
      end
    end

    describe "Authentication#find_for" do
      it "returns nil when no auth exists" do
        authentication = Authentication.find_for( twitter )
        authentication.present?.should eq false
      end

      it "returns the object when present" do
        auth.update_attribute(:uid, twitter[:uid])
        auth.update_attribute(:provider, twitter[:provider])

        authentication = Authentication.find_for(twitter)
        authentication.persisted?.should eq true
      end
    end

    describe "self.#from_omniauth" do
      it "creates a new user when existing with auth email not found" do
        user = User.from_omniauth(facebook)
        User.last.should eq user
      end

      it "persists when email is found" do
        user = create(:user, email: facebook[:info][:email])
        User.from_omniauth(facebook).should eq user
      end

      it "adds auth_present flag" do
        user = User.from_omniauth(facebook)
        user.auth_present?.should be_true
      end
    end

    describe "#has_auth?" do
      it "responds true when true for twitter" do
        user.attach_social(twitter)
        user.has_auth?(:twitter).should be_true
      end

      it "responds true when true for facebook" do
        user.attach_social(facebook)
        user.has_auth?(:facebook).should be_true
      end

      it "responds false when false for twitter" do
        user.has_auth?(:twitter).should be_false
      end

      it "responds false when false for false" do
        user.has_auth?(:facebook).should be_false
      end
    end
  end

  describe "user thankings" do
    let(:workout) { create(:workout) }
    let(:foo) { create(:user) }
    let(:bar) { create(:user) } 
    let(:thanking_for_foo) { create(:thanking, resource_id: workout.id, user_id: foo.id, thanker_id: bar.id) }
    let(:thanking_for_bar) { create(:thanking, resource_id: workout.id, user_id: bar.id, thanker_id: foo.id) }
    
    it "calls the right user as the thanker" do
      foo.thankings.should include thanking_for_bar
      bar.thankings.should include thanking_for_foo
    end

    it "calls the right user as the user being thanked" do
      foo.thanks.should include thanking_for_foo
      bar.thanks.should include thanking_for_bar
    end
  end
end
