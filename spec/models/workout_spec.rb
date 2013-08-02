# == Schema Information
#
# Table name: workouts
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  description    :text
#  user_id        :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  comments_count :integer         default(0), not null
#  likes_count    :integer         default(0), not null
#

require 'spec_helper'

describe Workout do

	let(:workout) { create(:workout) }
	subject { workout }

	it { should accept_nested_attributes_for :exercises }

	describe "validations" do
		it { should validate_presence_of(:name) }
		it { should validate_presence_of(:description) }
	end

	describe "associations" do
		it { should belong_to(:user) }
		it { should have_many(:comments) }
		it { should have_many(:exercises) }
		it { should have_many(:feeds) }
	end

	describe "images and videos" do
		xit { should have_attached_file(:photo) }
		xit { should have_attached_file(:workout_video) }
	end

end
