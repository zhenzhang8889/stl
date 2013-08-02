require 'spec_helper'
describe "compliment Integration" do
	let(:user) { create(:user) } 
	let(:current_user) { create(:user) }
	before do
		visit new_user_session_path
		fill_in "user_login", with: current_user.email
		fill_in "user_password", with: current_user.password
		click_button "Sign in"
	end

	it "should be in an account" do
		page.should have_selector(".alert-notice") { |alert| alert =~ /successfully/ }
	end

	describe "complimenting" do
		context "from user profile" do
			before do
				user
				visit user_path(user)
			end

			subject { page }

			it { should have_link("a", text: "Compliment") }

			it "should not show any model boxes", :js => true do
				find(:new_compliment).should_not be_visible
			end

			it "should open model on click", :js => true do
				click_link "Compliment"
				sleep 1
				find(:new_compliment).should be_visible
			end

			describe "with valid info" do
				before do
					click_link "Compliment"
					sleep 1
					fill_in "compliment_custom_message", with: "You're awesome"
					click_button "Compliment"
				end

				it "should be successful" do
					page.should have_content("You just complimented #{user.name}!")
				end

				it "should be on the users page" do
					current_path.should eq "/users/#{user.id}"
				end
			end
		end
	end

	describe "user compliments index", :js => true do
		before do
			user
			visit user_path(user)
			click_link "Compliment"
			sleep 1
			fill_in "compliment_custom_message", with: "You're awesome"
			click_button "Compliment"
			visit compliments_user_path(user)
		end

		it "should be on the right page" do
			current_path.should eq "/users/#{user.id}/compliments"
		end

		it "should list the new compliment" do
			page.should have_content("You're awesome")
		end
	end
end