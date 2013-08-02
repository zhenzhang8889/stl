require "spec_helper"

describe "User Relationships" do
	describe "following a user" do
		let(:user) { create(:user) }
		let(:other_user) { create(:user) }
		before do
			other_user
			visit new_user_session_path
			fill_in "user_login", with: user.email
			fill_in "user_password", with: user.password
			click_button "Sign in"
			visit user_path(other_user)
		end

		it "should be on other users profile page" do
			page.should have_selector("h1", text: other_user.name)
		end

		it "should show follow button" do
			page.should have_selector("input", value: "Follow")
		end

		xit "should follow the other_user when follow is clicked", :js => true do
			click_button "Follow"
			page.should have_selector(:followers, text: "1")
		end

		it "should show unfollow when user is already followed" do
			click_button "Follow"
			page.should have_selector("input", value: "Unfollow")
		end

		xit "should unfollow when unfollow is clicked" do
			click_button "Follow"
			click_button "Unfollow"
			page.should have_selector(:followers, text: "0")
		end

		it "should send a notification" do
			lambda {
			    click_button "Follow"
			  }.should change(Delayed::Job, :count).by(1)
		end
	end
end