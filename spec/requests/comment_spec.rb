require 'spec_helper'


describe "comments" do
  let(:user) { create(:user) }
  let(:current_user) { create(:user) }
  let(:post) { create(:post) }
  let(:comment) { create(:comment) }
  xit "allows logged in user to leave a comment on post", :js => true do
    visit new_user_session_path
    fill_in "user_login", with: current_user.email
    fill_in "user_password", with: current_user.password
    click_button "Sign in"
    visit post_path(id: post.id)
    fill_in "comment_content",with: comment.content
    click_button "Comment"
    page.should have_content("comment was successfully created.")
  end
end