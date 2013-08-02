require 'spec_helper'

describe Compliment do
	let(:compliment) { create(:compliment) }
	subject { compliment }

	describe "state" do
		it { should be_valid }
	end

	describe "model attributes" do
		it { should respond_to(:user) }
		it { should respond_to(:motivator) }
		it { should respond_to(:message) }
	end

	describe "associations" do
		it { should belong_to(:user) }

		it "should create a counter_cache on the user" do
			compliment.reload
			compliment.user.compliments_count.should eq 1
		end
	end

	describe "virtual attributes" do
		it { should respond_to(:canned_message) }
		it { should respond_to(:custom_message) }

		it "should save a message out of the virtual attributes" do
			compliment.message.should eq compliment.custom_message
		end

		it "should save canned if custom isn't present" do
			canned = create(:with_canned)
			canned.message.should eq canned.canned_message
		end

		it "should used custom if both are supplied" do
			with_both = create(:with_both)
			with_both.message.should eq with_both.custom_message
		end

		it "should not save a message longer than 160 char" do
			long_message = build(:with_long_message)
			long_message.should_not be_valid
		end
	end

	describe "instance methods" do
		it { should respond_to(:motivator) }
	end

	describe "validations" do
	  it { should validate_presence_of(:user_id) }
	  it { should validate_presence_of(:motivator_id) }

	  it "should validate that one of the message options are present" do
	  	invalid_compliment = build(:invalid_compliment)
	  	invalid_compliment.should_not be_valid
	  end
	end

	describe "accessibe attributes" do
		it { should_not allow_mass_assignment_of(:user_id) }
	end  
end

