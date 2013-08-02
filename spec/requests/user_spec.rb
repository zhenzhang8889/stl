require 'spec_helper'

describe "user pages interaction" do
	before(:each) do
		visit root_path
		lambda { click_link_or_button "Sign out" }
		User.delete_all
	end
	describe "registration page" do
		before { visit new_user_registration_path }
		subject { page }

		it { should have_selector("a", text: "Sign in with Twitter") }
		it { should have_selector("a", text: "Sign in with Facebook") }
		it { should have_selector("form#new_user") }
		it { should have_button("Sign up") }
	end

	describe "login page" do
		before { visit new_user_session_path }
		subject { page }

		it { should have_selector("a", text: "Sign in with Twitter") }
		it { should have_selector("a", text: "Sign in with Facebook") }
		it { should have_selector("form#signin_form") }
		it { should have_button("Sign in") }
	end

	describe "basic registration" do
		context "with valid information" do
			let(:valid_user) { build(:user) }
			before do
				visit new_user_registration_path
				fill_in "user_name", with: valid_user.name
				fill_in "user_email", with: valid_user.email
				fill_in "user_username", with: valid_user.username
				fill_in "user_password", with: valid_user.password
				fill_in "user_password_confirmation", with: valid_user.password_confirmation
				click_button "Sign up"
			end

			subject { page }

			its(:current_path) { should eq('/') }
			it { should have_content(valid_user.name) }
			it { should have_selector(".alert-notice", text: "Welcome! You have signed up successfully.") }
		end

		context "with invalid information" do
			before { visit new_user_registration_path }

			it "renders registration form again with invalid info" do
				click_button "Sign up"
				current_path.should eq('/users')
			end

			it "flashes error message with invalid info" do
				click_button "Sign up"
				page.should have_selector(".alert-error", text: "Please review the problems below:")
			end

			it "persists data on invalid info" do
				fill_in "user_name", with: "Foo Bar"
				click_button "Sign up"
				find_field('user_name').value.should eq 'Foo Bar'
			end

			it "highlights error field in red when invalid" do
				fill_in "user_name", with: "Foo Bar"
				fill_in "user_username", with: "Foobar"
				click_button "Sign up"
				page.should have_selector(".email.required.error")
				page.should have_selector(".password.required.error")
			end

			it "shows message in red next to field when invalid" do
				click_button "Sign up"
				page.should have_selector(".email.required.error .help-inline", text: "can't be blank")
			end
		end
	end

	describe "social" do
		describe "no current_user, no existing authentications" do
			context "with facebook" do
				before do
					visit new_user_registration_path
					click_link_or_button "Sign in with Facebook"
				end

				it "creates a user" do
					User.count.should eq 1
					User.last.email.should eq "foo@bar.com"
				end

				it "creates an authentication" do
					Authentication.count.should eq 1
				end

				it "associates the authentication with the user" do
					Authentication.last.user_id.should eq User.first.id
				end

				it "signes a user in" do
					page.should have_content "Signed in!"
					current_path.should eq root_path
				end
			end

			
			context "with google" do
				before do
					visit new_user_registration_path
					click_link_or_button "Sign in with Google Oauth2"
				end
				
				it "brings user to registration page" do
					current_path.should eq new_user_registration_path
				end

				it "should be asking for email" do
					page.should have_selector(".string.required.error")
				end

				it "should not have password fields" do
					page.should_not have_selector(:user_password)
					page.should_not have_selector(:user_password_confirmation)
				end

				it "should log a user in when email is entered" do
					fill_in "user_username", with: "foosbar"
		   		    click_button "Sign up"
		   		    page.should have_selector(".alert-notice") { |alert| alert =~ /successfully/ }
				end

				it "creates a user" do
					fill_in "user_username", with: "foosbar"
		   		    click_button "Sign up"
					User.count.should eq 1
				end

				it "creates an authentication" do
					fill_in "user_username", with: "foosbar"
		   		    click_button "Sign up"
					Authentication.count.should eq 1
				end

				it "associates the authentication with the user" do
					fill_in "user_username", with: "foosbar"
		   		    click_button "Sign up"
					Authentication.last.user_id.should eq User.first.id
				end
			end

			context "with twitter" do
				before do
					visit new_user_registration_path
					click_link_or_button "Sign in with Twitter"
				end
				
				it "brings user to registration page" do
					current_path.should eq new_user_registration_path
				end

				it "should be asking for email" do
					page.should have_selector(".email.required.error")
				end

				it "should not have password fields" do
					page.should_not have_selector(:user_password)
					page.should_not have_selector(:user_password_confirmation)
				end

				it "should log a user in when email is entered" do
					fill_in "user_email", with: "foo@bar.com"
		   		    click_button "Sign up"
		   		    page.should have_selector(".alert-notice") { |alert| alert =~ /successfully/ }
				end

				it "creates a user" do
					fill_in "user_email", with: "foo@bar.com"
		   		    click_button "Sign up"
					User.count.should eq 1
				end

				it "creates an authentication" do
					fill_in "user_email", with: "foo@bar.com"
		   		    click_button "Sign up"
					Authentication.count.should eq 1
				end

				it "associates the authentication with the user" do
					fill_in "user_email", with: "foo@bar.com"
		   		    click_button "Sign up"
					Authentication.last.user_id.should eq User.first.id
				end
			end

			context "with linkedin" do
				before do
					visit new_user_registration_path
					click_link_or_button "Sign in with Linkedin"
				end
				
				it "brings user to registration page" do
					current_path.should eq new_user_registration_path
				end

				it "should be asking for email and username" do
					page.should have_selector(".email.required.error")
					page.should have_selector(".string.required.error")
				end

				it "should not have password fields" do
					page.should_not have_selector(:user_password)
					page.should_not have_selector(:user_password_confirmation)
				end

				it "should log a user in when email and username is entered" do
					fill_in "user_email", with: "foo@bar.com"
					fill_in "user_username", with: "foosbar"
		   		    click_button "Sign up"
		   		    page.should have_selector(".alert-notice") { |alert| alert =~ /successfully/ }
				end

				it "creates a user" do
					fill_in "user_email", with: "foo@bar.com"
					fill_in "user_username", with: "foosbar"
		   		    click_button "Sign up"
					User.count.should eq 1
				end

				it "creates an authentication" do
					fill_in "user_email", with: "foo@bar.com"
					fill_in "user_username", with: "foosbar"
		   		    click_button "Sign up"
					Authentication.count.should eq 1
				end

				it "associates the authentication with the user" do
					fill_in "user_email", with: "foo@bar.com"
					fill_in "user_username", with: "foosbar"
		   		    click_button "Sign up"
					Authentication.last.user_id.should eq User.first.id
				end
			end
		end

		describe "no authentications but current_user" do
			let(:no_social_user) { create(:user) }
			before do
				visit new_user_session_path
				fill_in "user_login", with: no_social_user.email
				fill_in "user_password", with: no_social_user.password
				click_button "Sign in"
				visit edit_user_registration_path(no_social_user)
			end

			[:twitter, :facebook, :linkedin, :google_oauth2].each do |provider|

				context "with #{provider.to_s}" do
					it "authorizes" do
						click_link_or_button "Authorize #{provider.to_s.capitalize}"
						page.should have_content "#{provider.to_s.capitalize} Added"
						current_path.should eq edit_user_registration_path(no_social_user)
					end

					it "adds authorization to the current_user" do
						click_link_or_button "Authorize #{provider.to_s.capitalize}"
						no_social_user.authentications.count.should eq 1
						no_social_user.authentications.first.provider.should eq provider.to_s
					end
				end
			end

			context "with multiple" do
				it "authorizes both and now user has multiple auths" do
					click_link_or_button "Authorize Facebook"
					click_link_or_button "Authorize Twitter"
					click_link_or_button "Authorize Linkedin"
					click_link_or_button "Authorize Google_oauth2"
					no_social_user.authentications.count.should eq 4
				end
			end
		end

		describe "authentication but no current_user" do
			context "with facebook" do
				before do 
					visit new_user_registration_path
					click_link_or_button "Sign in with Facebook"
					click_link "Sign out"
				end

				it "already has user and auth" do
					User.count.should eq 1
					Authentication.count.should eq 1
					User.first.authentications.count.should eq 1
				end

				it "signs the user in" do
					visit new_user_session_path
					click_link_or_button "Sign in with Facebook"
					page.should have_selector(".alert-notice") { |alert| alert =~ /successfully/ }
				end

				it "doesn't add any more auths or users" do
					User.count.should eq 1
					Authentication.count.should eq 1
					User.first.authentications.count.should eq 1
				end

				it "updates auth record on login" do
					authentication = Authentication.last
					last_updated = authentication.updated_at
					visit new_user_session_path
					click_link_or_button "Sign in with Facebook"
					authentication.reload
					authentication.updated_at.should be > last_updated
				end
			end

			context "with twitter" do
				before do 
					visit new_user_registration_path
					click_link_or_button "Sign in with Twitter"
					fill_in "user_email", with: "foo@bar.com"
		   		    click_button "Sign up"
					click_link "Sign out"
				end

				it "already has user and auth" do
					User.count.should eq 1
					Authentication.count.should eq 1
					User.first.authentications.count.should eq 1
				end

				it "signs the user in" do
					visit new_user_session_path
					click_link_or_button "Sign in with Twitter"
					page.should have_selector(".alert-notice") { |alert| alert =~ /successfully/ }
				end

				it "doesn't add any more auths or users" do
					User.count.should eq 1
					Authentication.count.should eq 1
					User.first.authentications.count.should eq 1
				end
			end

			context "with linkedin" do
				before do 
					visit new_user_registration_path
					click_link_or_button "Sign in with Linkedin"
					fill_in "user_email", with: "foo@bar.com"
					fill_in "user_username", with: "foosbar"
		   		    click_button "Sign up"
					click_link "Sign out"
				end

				it "already has user and auth" do
					User.count.should eq 1
					Authentication.count.should eq 1
					User.first.authentications.count.should eq 1
				end

				it "signs the user in" do
					visit new_user_session_path
					click_link_or_button "Sign in with Linkedin"
					page.should have_selector(".alert-notice") { |alert| alert =~ /successfully/ }
				end

				it "doesn't add any more auths or users" do
					User.count.should eq 1
					Authentication.count.should eq 1
					User.first.authentications.count.should eq 1
				end
			end

			context "with google" do
				before do 
					visit new_user_registration_path
					click_link_or_button "Sign in with Google Oauth2"
					fill_in "user_username", with: "foosbar"
		   		    click_button "Sign up"
					click_link "Sign out"
				end

				it "already has user and auth" do
					User.count.should eq 1
					Authentication.count.should eq 1
					User.first.authentications.count.should eq 1
				end

				it "signs the user in" do
					visit new_user_session_path
					click_link_or_button "Sign in with Google Oauth2"
					page.should have_selector(".alert-notice") { |alert| alert =~ /successfully/ }
				end

				it "doesn't add any more auths or users" do
					User.count.should eq 1
					Authentication.count.should eq 1
					User.first.authentications.count.should eq 1
				end
			end
		end

		describe "remove authorizations" do
			before do 
				visit new_user_registration_path
				click_link_or_button "Sign in with Facebook"
				click_link "Settings"
			end

			xit "deletes the authorization record" do
				Authentication.count.should eq 1
				click_link_or_button "Remove Facebook Authorization"
				Authentication.count.should eq 0
			end
		end

		describe "error cases" do
			[:twitter,:facebook, :linkedin].each do |social|
				context "with unsuccsessful #{social} login" do
					before do
						OmniAuth.config.mock_auth[:"#{social}"] = :invalid_credentials
						visit new_user_registration_path
						click_link_or_button "Sign in with #{social.to_s.capitalize}"
					end

					subject { page }

					its(:current_path) { should eq "/users/sign_in" }
					it { should have_selector(".alert-alert") { |alert| alert =~ /Invalid credentials/ } }
				end
			end

			context "with unsuccsessful google login" do
				before do
					OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
					visit new_user_registration_path
					click_link_or_button "Sign in with Google Oauth2"
				end

				subject { page }

				its(:current_path) { should eq "/users/sign_in" }
				it { should have_selector(".alert-alert") { |alert| alert =~ /Invalid credentials/ } }
			end
		end
	end

	describe "login" do
		context "with valid basic information" do
			let(:valid_user) { create(:user) }
			before { visit new_user_session_path }

			it "allows login with email" do
				fill_in "user_login", with: valid_user.email
				fill_in "user_password", with: valid_user.password
				click_button "Sign in"

				page.should have_content(valid_user.name)
				current_path.should eq('/')
			end

			it "allows login with username" do
				fill_in "user_login", with: valid_user.username
				fill_in "user_password", with: valid_user.password
				click_button "Sign in"

				page.should have_content(valid_user.name)
				current_path.should eq('/')
			end

			it "should successful flash message" do
				fill_in "user_login", with: valid_user.username
				fill_in "user_password", with: valid_user.password
				click_button "Sign in"

				page.should have_selector(".alert-notice", text: "Signed in successfully.")
			end
		end

		context "with invalid basic information" do
			before :each do
				visit new_user_session_path
				click_button "Sign in"
			end

			it "renders the login form" do
				current_path.should eq '/users/sign_in'
				page.should have_selector(:signin_form)
			end

			it "flashes error message" do
				page.should have_selector(".alert-alert", text: "Invalid: login or password.")
			end

			it "persists email" do
				fill_in "user_login", with: "foo@bar.com"
				click_button "Sign in"
				find_field('user_login').value.should eq 'foo@bar.com'
			end
		end
	end

	describe "profile page" do
		let(:user) { create(:user) }
		let(:status) { build(:status, user_id: user.id) }
		before do 
			visit new_user_session_path
			fill_in "user_login", with: user.username
			fill_in "user_password", with: user.password
			click_button "Sign in"
			fill_in "status_content", with: status.content
			click_button "Post"
			visit user_path(user)
		end

		subject { page }

		its(:current_path) { should eq("/users/#{user.id}") }
		it { should have_content(user.name) }
		it { should have_content(status.content) }

		context "with admin access" do
			xit "allows for deletion of microposts" do

			end
		end

		context "without admin access" do
			xit "doesn't allow for deletion of microposts" do

			end
		end
	end

	describe "settings page" do
		let(:user) { create(:user) }
		before do 
			visit new_user_session_path
			fill_in "user_login", with: user.username
			fill_in "user_password", with: user.password
			click_button "Sign in"
			visit edit_user_registration_path(user)
		end

		subject { page }

		it { should have_selector("form#edit_user") }

		["user_email", "user_username", "user_name", "user_password", 
			"user_password_confirmation", "user_goals", 
			"user_interest_list", "user_bio", "user_gender"].each do |field|
			it { should have_selector :"#{field}" }
		end

		it "should allow for update of information" do
			fill_in :user_bio, with: "I am awesome"
			click_button "Update"
			find_field(:user_bio).value.should =~ /awesome/
		end

		it "renders error message on invalid updated info" do
			fill_in "user_email", with: "I am awesome"
			click_button "Update"
			page.should have_selector(".alert-error", text: "Please review the problems below:")
		end

		it "doesn't require password for basic user update info" do
			fill_in "user_username", with: "something"
			click_button "Update"
			page.should have_selector(".alert-notice") { |alert| alert =~ /successfully/ }
		end
	end

	describe "users index page" do
		let(:user) { create(:user) }
		before do 
			visit new_user_session_path
			fill_in "user_login", with: user.username
			fill_in "user_password", with: user.password
			click_button "Sign in"
			visit users_path
		end

		it "lists users with link to profile" do
			page.should have_selector("a", text: user.name, href: user_path(user))
		end

		context "with admin access" do
			xit "allows for deletion of users" do

			end
		end

		context "without admin access" do
			xit "does not allow for deletion of users" do

			end
		end
	end
end