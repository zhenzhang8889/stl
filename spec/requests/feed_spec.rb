require 'spec_helper'

describe "dashboard feed" do
	let(:current_user) { create(:user) }
	let(:followed_user) { create(:user) }
	let!(:relationship) { create(:relationship, followed_id: followed_user.id, follower_id: current_user.id) }

	before do
		visit new_user_session_path
		fill_in "user_login", with: current_user.email
		fill_in "user_password", with: current_user.password
		click_button "Sign in"
	end
	
	context "for a status" do
		let(:my_status) { create(:status, user_id: current_user.id) }
		let(:followed_status) { create(:status, :user_id => followed_user.id) }

		it "shows status for users followed" do
			followed_status
			relationship
			visit root_path
			page.should have_content followed_status.content
		end

		it "shows status from yourself" do
			page.should_not have_content 'Foo Status'
			fill_in "status_content", with: "Foo Status"
			click_button "Post"
			page.should have_content 'Foo Status'
		end

		it "allows liking and unliking of others status", js: true do
			Like.count.should eq 0
			followed_status
			relationship
			visit root_path
			find(".like_feed_item_#{followed_status.feeds.first.id} > a").click
			find(".like_feed_item_#{followed_status.feeds.first.id}").should have_content "Unlike"
			Like.count.should eq 1
			find(".like_feed_item_#{followed_status.feeds.first.id} > a").click
			find(".like_feed_item_#{followed_status.feeds.first.id}").should have_content "Like"
			Like.count.should eq 0
		end


		it "allows liking and unliking of your status", js: true do
			fill_in "status_content", with: "Foo Status"
			click_button "Post"
			Like.count.should eq 0
			find(".like_feed_item_#{Status.last.feeds.first.id} > a").click
			find(".like_feed_item_#{Status.last.feeds.first.id}").should have_content "Unlike"
			Like.count.should eq 1
			find(".like_feed_item_#{Status.last.feeds.first.id} > a").click
			find(".like_feed_item_#{Status.last.feeds.first.id}").should have_content "Like"
			Like.count.should eq 0
		end

		xit "allow thanking of status", js: true do
			followed_status
			relationship
			visit root_path
			Thanking.count.should eq 0
			find(".thank_feed_item_#{followed_status.feeds.first.id} > a").click
			sleep 20
			wait_for_ajax
			Thanking.count.should eq 1
			find(".thank_feed_item_#{followed_status.feeds.first.id}").should have_content "You thanked #{followed_user.name}"
		end

		xit "doesn't allow thanking of your own status" do
			fill_in "status_content", with: "Foo Status"
			click_button "Post"
			page.should_not have_selector(".thank_feed_item_#{Status.last.feeds.first.id}")
		end

		xit "allows comments on status", js: true do
			followed_status
			relationship
			visit root_path
			fill_in "comment_content", with: "Commenting yo!"
			mimic_return("comment_content")
			page.should have_selector("ul.cl_#{Comment.last.id}.comment_list", text: "Commenting yo!")
			find(:xpath, "//input[@id='comment_content']").value.should eq ""
			Comment.count.should eq 1
		end

		xit "allows likes and unlikes on comments", js: true do
			followed_status
			relationship
			visit root_path
			fill_in "comment_content", with: "Commenting yo!"
			mimic_return("comment_content")
			find(".like_comment_item_#{Comment.last.id} > a").click
			Like.count.should eq 1
			find(".like_comment_item_#{Comment.last.id}").should have_content "Unlike"
			find(".like_comment_item_#{Comment.last.id} > a").click
			find(".like_comment_item_#{Comment.last.id}").should have_content "Like"
			Like.count.should eq 0
		end
	end

	context "for a post" do
		let(:my_post) { create(:post, user_id: current_user.id) }
		let(:followed_post) { create(:post, :user_id => followed_user.id) }

		it "shows post for users followed" do
			followed_post
			relationship
			visit root_path
			page.should have_content followed_post.body
		end

		it "shows post from yourself" do
			page.should_not have_content my_post.body
			my_post
			visit root_path
			page.should have_content my_post.body
		end

		it "allows liking and unliking of others posts", js: true do
			Like.count.should eq 0
			followed_post
			relationship
			visit root_path
			find(".like_feed_item_#{followed_post.feeds.first.id} > a").click
			find(".like_feed_item_#{followed_post.feeds.first.id}").should have_content "Unlike"
			Like.count.should eq 1
			find(".like_feed_item_#{followed_post.feeds.first.id} > a").click
			find(".like_feed_item_#{followed_post.feeds.first.id}").should have_content "Like"
			Like.count.should eq 0
		end


		it "allows liking and unliking of your post", js: true do
			my_post
			visit root_path
			Like.count.should eq 0
			find(".like_feed_item_#{Post.last.feeds.first.id} > a").click
			find(".like_feed_item_#{Post.last.feeds.first.id}").should have_content "Unlike"
			Like.count.should eq 1
			find(".like_feed_item_#{Post.last.feeds.first.id} > a").click
			find(".like_feed_item_#{Post.last.feeds.first.id}").should have_content "Like"
			Like.count.should eq 0
		end

		xit "allow thanking of post", js: true do
			followed_post
			relationship
			visit root_path
			Thanking.count.should eq 0
			find(".thank_feed_item_#{followed_post.feeds.first.id} > a").click
			wait_for_ajax
			Thanking.count.should eq 1
			find(".thank_feed_item_#{followed_post.feeds.first.id}").should have_content "You thanked #{followed_user.name}"
		end

		xit "doesn't allow thanking of your own post" do
			my_post
			visit root_path
			page.should_not have_selector(".thank_feed_item_#{Post.last.feeds.first.id}")
		end

		xit "allows comments on post", js: true do
			followed_post
			relationship
			visit root_path
			fill_in "comment_content", with: "Commenting yo!"
			mimic_return("comment_content")
			page.should have_selector("ul.cl_#{Comment.last.id}.comment_list", text: "Commenting yo!")
			find(:xpath, "//input[@id='comment_content']").value.should eq ""
			Comment.count.should eq 1
		end

		xit "allows likes and unlikes on comments", js: true do
			followed_post
			relationship
			visit root_path
			fill_in "comment_content", with: "Commenting yo!"
			mimic_return("comment_content")
			find(".like_comment_item_#{Comment.last.id} > a").click
			Like.count.should eq 1
			find(".like_comment_item_#{Comment.last.id}").should have_content "Unlike"
			find(".like_comment_item_#{Comment.last.id} > a").click
			find(".like_comment_item_#{Comment.last.id}").should have_content "Like"
			Like.count.should eq 0
		end
	end

	context "for a workout" do
		let(:my_workout) { create(:workout, user_id: current_user.id) }
		let(:followed_workout) { create(:workout, :user_id => followed_user.id) }

		it "shows workout for users followed" do
			followed_workout
			relationship
			visit root_path
			page.should have_content followed_workout.description
		end

		it "shows workout from yourself" do
			page.should_not have_content my_workout.description
			my_workout
			visit root_path
			page.should have_content my_workout.description
		end

		it "allows liking and unliking of others workout", js: true do
			Like.count.should eq 0
			followed_workout
			relationship
			visit root_path
			find(".like_feed_item_#{followed_workout.feeds.first.id} > a").click
			find(".like_feed_item_#{followed_workout.feeds.first.id}").should have_content "Unlike"
			Like.count.should eq 1
			find(".like_feed_item_#{followed_workout.feeds.first.id} > a").click
			find(".like_feed_item_#{followed_workout.feeds.first.id}").should have_content "Like"
			Like.count.should eq 0
		end


		it "allows liking and unliking of your workout", js: true do
			my_workout
			visit root_path
			Like.count.should eq 0
			find(".like_feed_item_#{Workout.last.feeds.first.id} > a").click
			find(".like_feed_item_#{Workout.last.feeds.first.id}").should have_content "Unlike"
			Like.count.should eq 1
			find(".like_feed_item_#{Workout.last.feeds.first.id} > a").click
			find(".like_feed_item_#{Workout.last.feeds.first.id}").should have_content "Like"
			Like.count.should eq 0
		end

		xit "allow thanking of workout", js: true do
			followed_workout
			relationship
			visit root_path
			Thanking.count.should eq 0
			find(".thank_feed_item_#{followed_workout.feeds.first.id} > a").click
			wait_for_ajax
			Thanking.count.should eq 1
			find(".thank_feed_item_#{followed_workout.feeds.first.id}").should have_content "You thanked #{followed_user.name}"
		end

		xit "doesn't allow thanking of your own post" do
			my_workout
			visit root_path
			page.should_not have_selector(".thank_feed_item_#{Workout.last.feeds.first.id}")
		end

		xit "allows comments on workout", js: true do
			followed_workout
			relationship
			visit root_path
			fill_in "comment_content", with: "Commenting yo!"
			mimic_return("comment_content")
			page.should have_selector("ul.cl_#{Comment.last.id}.comment_list", text: "Commenting yo!")
			find(:xpath, "//input[@id='comment_content']").value.should eq ""
			Comment.count.should eq 1
		end

		xit "allows likes and unlikes on comments", js: true do
			followed_workout
			relationship
			visit root_path
			fill_in "comment_content", with: "Commenting yo!"
			mimic_return("comment_content")
			find(".like_comment_item_#{Comment.last.id} > a").click
			Like.count.should eq 1
			find(".like_comment_item_#{Comment.last.id}").should have_content "Unlike"
			find(".like_comment_item_#{Comment.last.id} > a").click
			find(".like_comment_item_#{Comment.last.id}").should have_content "Like"
			Like.count.should eq 0
		end
	end
end