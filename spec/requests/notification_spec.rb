require 'spec_helper'

describe "notifications trigger", js: true do
	let(:user) { create(:user) } 
	let(:current_user) { create(:user) }
	let(:user_post) { create(:post, user_id: user.id) }
	before do
		visit new_user_session_path
		fill_in "user_login", with: current_user.email
		fill_in "user_password", with: current_user.password
		click_button "Sign in"
		visit user_path(user)
		click_link_or_button "Follow"
		wait_for_ajax
	end

	describe "user follows user" do
		it "delegates a notification" do
			Delayed::Job.count.should eq 1
		end
	end

	describe "like a feed item" do
		it "delegates a notification" do
			user_post
			visit root_path
			lambda {
			    click_link "Like"
			    wait_for_ajax
			}.should change(Delayed::Job, :count).by(1)
		end
	end

	describe "comment a content instance" do
		it "delegates a notification" do
			user_post
			visit root_path
			fill_in "comment_content", with: "Foo"
			lambda {
			   	page.execute_script("$('form#new_comment').submit()")
			    wait_for_ajax
			}.should change(Delayed::Job, :count).by(1)
		end
	end

	describe "like a comment on content item" do
		it "delegates a notification" do
			user_post
			user.comments.create!(:commentable_id => user_post.id, 
				:commentable_type => "Post", :content => "foo")
			visit root_path
			find("a.drop_comments").click
			lambda {
			   	find(".comment_body a.like").click
				wait_for_ajax
			}.should change(Delayed::Job, :count).by(1)
		end
	end

	describe "like a content show" do
		it "delegates a notification" do
			user_post
			visit post_path(user_post)
			lambda {
			   	click_link_or_button "Like"
			    wait_for_ajax
			}.should change(Delayed::Job, :count).by(1)
		end
	end

	describe "user compliments user" do
		it "delegates a notification" do
			visit user_path(user)
			click_link "Compliment"
			sleep 1
			fill_in "compliment_custom_message", with: "You're awesome"
			lambda {
			   	click_button "Compliment"
			}.should change(Delayed::Job, :count).by(1)
		end
	end

	describe "user shares content" do
		it "delegates a notification" do
			visit root_path
			find("#status_content").click
			fill_in "status_content", with: "foo"
			click_link "Share"
			page.execute_script("$('#shareStatus ul.tagit input').attr('id', 'foo')")
			fill_in "foo", with: user.email
			lambda {
			   	click_link_or_button "Post"
			}.should change(Delayed::Job, :count).by(1)
		end
	end

	describe "user commented on a post other_user also commented on" do
		it "delegates a notification" do
			user_post
			current_user.comments.create!(:commentable_id => user_post.id, 
				:commentable_type => "Post", :content => "foo")
			click_link_or_button current_user.name
			click_link_or_button "Sign out"
			visit new_user_session_path
			fill_in "user_login", with: user.email
			fill_in "user_password", with: user.password
			click_button "Sign in"
			fill_in "comment_content", with: "Foo"
			lambda {
			   	page.execute_script("$('form#new_comment').submit()")
			    wait_for_ajax
			}.should change(Delayed::Job, :count).by(1)
		end
	end
end