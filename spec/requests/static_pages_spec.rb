require 'spec_helper'

# describe "Static pages" do

#   describe "Home page" do
#     it "renders the proper template" do
#       get "/"
#       response.should render_template(:home)
#     end

#     before { visit root_path }
#     subject { page }

#     describe "without a user signed in" do
#       it { should have_selector('a', text: "Sign in", href: "/users/sign_in" ) }
#       xit { should have_selector('a', text: "Sign up now!", href: "users/sign_up") }
#     end

#     describe "with a user signed in" do
#       let(:user) { FactoryGirl.create(:user) }
#       before do
#         click_link "Sign in"
#         fill_in "user_login", with: user.email
#         fill_in "user_password", with: user.password
#         click_button "Sign in"
#       end

#       subject { page }

#       its(:current_path) { should eq("/") }
#       it { should have_content(user.name) }
#       it { should have_selector("a", text: "Settings", href: edit_user_registration_path(user)) }
#       it { should have_selector("a", text: "Profile", href: user_path(user)) }
#       xit { should have_selector("a", text: "Users", href: users_path) }
#       it { should have_selector("a", text: "Sign out", href: "/users/sign_out") }
#     end
#   end

#   # describe "Help page" do

#   #   it "should have the h1 'Help'" do
#   #     visit '/static_pages/help'
#   #     page.should have_selector('h1', :text => 'Help')
#   #   end

#   #   it "should have the title 'Help'" do
#   #     visit '/static_pages/help'
#   #     page.should have_selector('title',
#   #                       :text => "Ruby on Rails Tutorial Sample App | Help")
#   #   end
#   # end

#   # describe "About page" do

#   #   it "should have the h1 'About Us'" do
#   #     visit '/static_pages/about'
#   #     page.should have_selector('h1', :text => 'About Us')
#   #   end

#   #   it "should have the title 'About Us'" do
#   #     visit '/static_pages/about'
#   #     page.should have_selector('title',
#   #                   :text => "Ruby on Rails Tutorial Sample App | About Us")
#   #   end
#   # end
# end