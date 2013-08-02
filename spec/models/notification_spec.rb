# == Schema Information
#
# Table name: notifications
#
#  id              :integer         not null, primary key
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  user_id         :integer
#  notify_method   :string(255)
#  notified        :boolean         default(FALSE)
#  notifiable_id   :integer
#  notifiable_type :string(255)
#  viewed          :boolean
#

require 'spec_helper'

describe Notification do
  	let(:email_notification) { create(:email_notification) }

  	subject { email_notification }

  	describe "factory" do
  		it { should be_valid }
  	end

  	describe "model attributes" do
		it { should respond_to(:email) }
		it { should respond_to(:notified) }
		it { should respond_to(:notify_method) }
		it { should respond_to(:behaviour) }
		it { should respond_to(:viewed) }
		it { should respond_to(:user_id) }
		it { should respond_to(:notifiable_id) }
		it { should respond_to(:notifiable_type) }
	end

	describe "associations" do
		it { should belong_to(:user) }
		it { should respond_to(:notifiable) }
	end

	describe "validations" do
	  it { should validate_presence_of(:user_id) }
	end

	describe "accessible attributes" do
		it { should_not allow_mass_assignment_of(:notifiable_id) }
	end

	describe "creating valid notification" do
		let(:relationship) { create(:relationship) }

		before do
			Notification.any_instance.stub(:send_for_email_and_deliver)
			Notification.create_and_delegate(relationship, relationship.followed, :follow, [:email, :site])
			@notifications = Notification.all
		end

		it "creates new notification objects" do
			@notifications.count.should eq 2
		end

		it "toggles notified" do
			@notifications.first.notified?.should be_true
			@notifications.last.notified?.should be_true
		end

		it "associates properly" do
			@notifications.first.notifiable.should eq relationship
			@notifications.first.user.should eq relationship.followed
		end
	end
end
