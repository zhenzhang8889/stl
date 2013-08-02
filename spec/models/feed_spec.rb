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

require 'spec_helper'

describe Feed do
	let(:workout) { create(:workout) }
	let(:status) { create(:status) }
	let(:post) { create(:post) }
	let(:w_feed) { create(:feed, user_id: workout.user_id,
						  feedable_id: workout.id,
						  feedable_type: "Workout") }
	let(:s_feed) { create(:feed, user_id: status.user_id,
						  feedable_id: status.id,
						  feedable_type: "Status") }
	let(:p_feed) { create(:feed, user_id: post.user_id,
						  feedable_id: post.id,
						  feedable_type: "Post") }

	describe "state" do
		["w_feed", "s_feed", "p_feed"].each do |item|
			it "should have a valid #{item} factory" do
				eval(item).should be_valid
			end
		end
	end

	describe "associations" do
		it { should belong_to(:user) }
		it { should belong_to(:feedable) }
	end

	describe "feed items created from content items" do

		context "when status" do
			let(:status_no_feed) { create(:status) }
			before { status_no_feed }

			it "creates a feed item when status is created" do
				Feed.count.should eq 1
			end

			it "sets the feed user_id to the status user" do
				feed = Feed.find_by_feedable_id(status_no_feed.id)
				feed.user_id.should eq status_no_feed.user_id
			end

			it "sets a counter_cache on the content user" do
				feed = Feed.find_by_feedable_id(status_no_feed.id)
				feed.user.feeds_count.should eq 1
			end
		end

		context "when post" do
			let!(:post_no_feed) { create(:post) }

			it "creates a feed item when status is created" do
				Feed.find_by_feedable_id(post_no_feed.id).should be_present
			end

			it "sets the feed user_id to the post user" do
				feed = Feed.find_by_feedable_id(post_no_feed.id)
				feed.user_id.should eq post_no_feed.user_id
			end	

			it "sets a counter_cache on the content user" do
				feed = Feed.find_by_feedable_id(post_no_feed.id)
				feed.user.feeds_count.should eq 1
			end
		end

		context "when workout" do
			let!(:workout_no_feed) { create(:workout) }

			it "creates a feed item when status is created" do
				Feed.find_by_feedable_id(workout_no_feed.id).should be_present
			end

			it "sets the feed user_id to the workout user" do
				feed = Feed.find_by_feedable_id(workout_no_feed.id)
				feed.user_id.should eq workout_no_feed.user_id
			end	

			it "sets a counter_cache on the content user" do
				feed = Feed.find_by_feedable_id(workout_no_feed.id)
				feed.user.feeds_count.should eq 1
			end
		end
	end

	describe "collecting feed for a user" do
		let(:follower) { create(:user) }
		let(:followed) { create(:user) }
		let!(:relationship) { create(:relationship,
									:follower_id => follower.id,
									:followed_id => followed.id) }
		let(:f_workout) { create(:workout, user_id: followed.id) }
		let(:f_status) { create(:status, user_id: followed.id) }
		let(:f_post) { create(:post, user_id: followed.id) }
		let(:random_workout) { create(:workout) }
		let(:random_status) { create(:status) }
		let(:random_post) { create(:post) }

		it "should give all feed items of followed to user doing the following" do
			Feed.from_users_followed_by(follower).should include f_workout.feeds.first
			Feed.from_users_followed_by(follower).should include f_status.feeds.first
			Feed.from_users_followed_by(follower).should include f_post.feeds.first
		end

		it "includes feed items posted by the user himself" do
			Feed.from_users_followed_by(followed).should include f_workout.feeds.first
			Feed.from_users_followed_by(followed).should include f_status.feeds.first
			Feed.from_users_followed_by(followed).should include f_post.feeds.first
		end

		it "doesn't include feed item if user doesn't follow that person" do
			Feed.from_users_followed_by(follower).should_not include random_workout.feeds.first
			Feed.from_users_followed_by(follower).should_not include random_status.feeds.first
			Feed.from_users_followed_by(follower).should_not include random_post.feeds.first
		end
	end

	describe "instance methods" do
		it "returns proper response for #is_a_workout?" do
			w_feed.is_a_workout?.should be_true
			p_feed.is_a_workout?.should_not be_true
			s_feed.is_a_workout?.should_not be_true
		end

		it "returns proper response for #is_a_status?" do
			s_feed.is_a_status?.should be_true
			w_feed.is_a_status?.should_not be_true
			p_feed.is_a_status?.should_not be_true
		end

		it "returns proper response for #is_a_post?" do
			p_feed.is_a_post?.should be_true
			w_feed.is_a_post?.should_not be_true
			s_feed.is_a_post?.should_not be_true
		end
	end
end
