require 'spec_helper'

# describe "adding and managing exercises" do 
# 	let(:current_user) { create(:user) }
# 	let(:workout) { create(:workout, :user_id => current_user.id) }
# 	let(:exercise1) { create(:exercise, workout_id: workout.id) }
# 	let(:exercise2) { create(:exercise, workout_id: workout.id) }

# 	before do
# 		visit new_user_session_path
# 		fill_in "user_login", with: current_user.email
# 		fill_in "user_password", with: current_user.password
# 		click_button "Sign in"
# 	end

# 	describe "adding exercises to a new workout", :js => true do
# 		before do 
# 			visit new_workout_path
# 			fill_in "workout_name", with: workout.name
# 			fill_in "workout_description", with: workout.description
# 		end

# 		it "should show new exercise form on 'Add Exercise' click" do
# 			click_link "Add Exercise"
# 			page.should have_css("#new-exercise-fieldset", :count=>1)
# 		end

# 		it "should validate field presence if left blank" do
# 			click_link "Add Exercise"
# 			click_link_or_button "Save changes"
# 			page.should have_content "* Exercises name can't be blank"
# 			page.should have_content "* Exercises name can't be blank"
# 		end

# 		it "should show extra fields on 'add more info' click" do
# 			click_link "Add Exercise"
# 			page.should_not have_selector(".in.collapse")
# 			click_link "Add More Info"
# 			page.should have_selector(".in.collapse")
# 		end

# 		it "should show 'add less info' button when info expanded" do
# 			click_link "Add Exercise"
# 			click_link "Add More Info"
# 			page.should have_link("Add Less Info")
# 		end

# 		it "should have remove link targeting the dom, not an object" do
# 			click_link "Add Exercise"
# 			page.should have_selector("a.remove-exercise")
# 		end

# 		it "should remove the box with 'remove' is clicked" do
# 			click_link "Add Exercise"
# 			page.should have_css("#new-exercise-fieldset")
# 			click_link "remove"
# 			page.should_not have_css("#new-exercise-fieldset")
# 		end
# 	end

# 	describe "modifying exercises on existing workout" do
# 		before do
# 			exercise1
# 			exercise2
# 			visit edit_workout_path(workout)
# 		end

# 		it "should show existing exercises with editable fields" do
# 			page.should have_selector(".exercise-#{exercise1.id}.row")
# 			page.should have_selector(".exercise-#{exercise2.id}.row")
# 		end

# 		it "should have object remove button" do
# 			page.should have_link("remove", href: "/exercises/#{exercise1.id}")
# 			page.should have_link("remove", href: "/exercises/#{exercise2.id}")
# 			page.should_not have_selector("a.remove-exercise")
# 		end

# 		it "should delete exercise from db when remove is clicked" do
# 			expect { 
# 				find("a.remove-exercise-#{exercise1.id}").click 
# 			}.to change(Exercise, :count).by(-1)
# 		end

# 		it "should remove exercise object from page when remove is clicked", :js => true do
# 			page.should have_selector(".exercise-#{exercise1.id}.row")
# 			find("a.remove-exercise-#{exercise1.id}").click
# 			sleep 10
# 			page.should_not have_selector(".exercise-#{exercise1.id}")
# 		end

# 		it "should have dom remove button when new exercise added", :js => true do
# 			click_link "Add Exercise"
# 			page.should have_css("#new-exercise-fieldset", :count=>3)
# 			page.should have_css("a.remove-exercise")
# 		end
# 	end
# end	