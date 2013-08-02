require 'spec_helper'


describe "likes" do
  let(:user) { create(:user) }
  let(:current_user) { create(:user) }
	let(:post) { create(:post) }
	let(:workout) { create(:workout) }
  let(:like) { create(:like) }
  
	
	
 		xit "allows logged in user to like or unlike a post", :js => true do
          
          visit new_user_session_path
       		fill_in "user_login", with: current_user.email
       		fill_in "user_password", with: current_user.password
       		click_button "Sign in"
          
          
				  visit post_path(id: post.id)
        
          click_link "Like!"
          page.should have_selector("a", text: "Unlike!", href: "post/#{post.id}/unlike")
          click_link "Unlike!"
          page.should have_selector("a", text: "Like!", href: "post/#{post.id}/like")
    end
    
    xit "allows logged in user to like or unlike a workout", :js => true do
          
          visit new_user_session_path
       		fill_in "user_login", with: current_user.email
       		fill_in "user_password", with: current_user.password
       		click_button "Sign in"
          
          
				  visit workout_path(id: workout.id)
        
          click_link "Like!"
          page.should have_selector("a", text: "Unlike!", href: "workout/#{workout.id}/unlike")
          click_link "Unlike!"
          page.should have_selector("a", text: "Like!", href: "workout/#{workout.id}/like")
    end
    
    
      
end