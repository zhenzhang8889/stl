require 'spec_helper'

describe "adding a link to a status's content", js: true do
	let(:link) { "http://railscasts.com"}
	let(:link_title) { "Ruby on Rails Screencasts - RailsCasts" }
	let(:link_desc) { "Short Ruby on Rails screencasts containing tips, tricks and tutorials. Great for both novice and expe..." }
	let(:link_img_count) { 18 }
	let(:current_user) { create(:user) }
	before do
		visit new_user_session_path
		fill_in "user_login", with: current_user.email
		fill_in "user_password", with: current_user.password
		click_button "Sign in"
	end

	context "when typing regular text" do
		it "doesn't show status spinner" do
			find("#link-loading").should_not be_visible
		end

		it "doesn't show #external_link_content" do
			find("#external_link_content").should_not be_visible
		end

		it "has empty values for attachment url hidden fields" do
			 find(:xpath, "//input[@id='status_attached_url']").value.should eq ""
			 find(:xpath, "//input[@id='status_attached_url_image']").value.should eq ""
			 find(:xpath, "//input[@id='status_attached_url_description']").value.should eq ""
			 find(:xpath, "//input[@id='status_attached_url_title']").value.should eq ""
		end

		it "doesn't do anything when typing regular text" do
			fill_in "status_content", with: Faker::Lorem.sentences(2)
			page.find_by_id("status_content").native.send_keys :space
			find("#link-loading").should_not be_visible
		end
	end

	context "typing a link" do
		it "starts ajax on spacebar" do
			fill_in "status_content", with: link
			page.find_by_id("status_content").native.send_keys :space
			find("#link-loading").should be_visible
		end

		it "fires ajax with www link as well" do
			fill_in "status_content", with: "http://www.google.ca"
			page.find_by_id("status_content").native.send_keys :space
			find("#link-loading").should be_visible
		end

		it "fires ajax with content before link" do
			fill_in "status_content", with: 'this is awesome '
			fill_in "status_content", with: link
			page.find_by_id("status_content").native.send_keys :space
			find("#link-loading").should be_visible
		end

		it "does not fire ajax on second link" do
			fill_in "status_content", with: link
			page.find_by_id("status_content").native.send_keys :space
			wait_for_link_fetch
			fill_in "status_content", with: "http://awesome.com"
			page.find_by_id("status_content").native.send_keys :space
			find("#link-loading").should_not be_visible
		end

		it "shows link box" do
			fill_in "status_content", with: link
			page.find_by_id("status_content").native.send_keys :space
			wait_for_link_fetch
			find("#external_link_content").should be_visible
		end

		describe "showing link box" do
			before do
				fill_in "status_content", with: link
				page.find_by_id("status_content").native.send_keys :space
				wait_for_link_fetch
			end

			it "shows the title" do
				page.should have_selector(:link_title, text: link_title)
			end

			it "shows the description" do
				page.should have_selector(:link_desc, text: link_desc)
			end

			it "shows the url" do
				page.should have_selector(:link_url, text: link)
			end

			it "shows the image count" do
				page.should have_selector(:atc_total_images_info, text: "1 of 18")
			end

			it "sorts through the images ASC" do
				find("img#1").should be_visible
				find("a#next").click
				find("img#1").should_not be_visible
				find("img#2").should be_visible
			end

			it "sorts through the images DESC" do
				find("img#1").should be_visible
				find("a#prev").click
				find("img#1").should_not be_visible
				find("img#18").should be_visible
			end

			it "removes box on click .clear-attached-link" do
				find("a.clear-attached-link").click
				find("#external_link_content").should_not be_visible
			end

			it "allows new link after one is removed" do
				find("a.clear-attached-link").click
				find("#external_link_content").should_not be_visible
				fill_in "status_content", with: ""
				fill_in "status_content", with: link
				mimic_spacebar("status_content")
				wait_for_link_fetch
				find("#external_link_content").should be_visible
			end

			it "doesn't show image box if no images" do
				find("a.clear-attached-link").click
				fill_in "status_content", with: "http://google.com"
				mimic_spacebar("status_content")
				wait_for_link_fetch
				find("#url_image_choices").should_not be_visible
				find("#atc_total_image_nav").should_not be_visible
				find("#atc_total_images_info").should_not be_visible
			end

			it "fails gracefully" do
				find("a.clear-attached-link").click
				fill_in "status_content", with: "http://twitter.com"
				mimic_spacebar("status_content")
				wait_for_ajax
				find("#link-loading").should_not be_visible
				find("#ajax_fetch_error").should be_visible
			end

			it "hides error mesesage after fail and new link try" do
				find("a.clear-attached-link").click
				fill_in "status_content", with: "http://twitter.com"
				mimic_spacebar("status_content")
				wait_for_ajax
				fill_in "status_content", with: "http://railscasts.com"
				mimic_spacebar("status_content")
				wait_for_ajax
				find("#ajax_fetch_error").should_not be_visible
			end

			it "removes thumb views on no thumb check" do
				check('No Thumbnail')
				find("#image_choices_total").should_not be_visible
				find("#url_image_choices").should_not be_visible
				find("#atc_total_image_nav").should_not be_visible
				find("#atc_total_images_info").should_not be_visible
				find("#check_no_thumb").should_not be_visible
			end

			it "removes image form value on no thumb check" do
				check('No Thumbnail')
				find(:xpath, "//input[@id='status_attached_url_image']").value.should eq ""
			end
		end

		describe "form input values" do
			before do
				fill_in "status_content", with: link
				page.find_by_id("status_content").native.send_keys :space
				wait_for_link_fetch
			end

			it "fills in the #visible_image with proper value" do
				find(:xpath, "//input[@id='visible_image']").value.should eq "1"
				find("a#next").click
				find(:xpath, "//input[@id='visible_image']").value.should eq "2"
				find("a#prev").click
				find("a#prev").click
				find(:xpath, "//input[@id='visible_image']").value.should eq "18"
			end

			it "populates the form fields with the first set of information" do
				find(:xpath, "//input[@id='status_attached_url']").value.should eq link
				find(:xpath, "//input[@id='status_attached_url_image']").value.should eq find("img#1")['src']
				find(:xpath, "//input[@id='status_attached_url_description']").value.should eq link_desc
				find(:xpath, "//input[@id='status_attached_url_title']").value.should eq link_title
			end

			it "doesn't populate image field if there are no images" do
				find("a.clear-attached-link").click
				fill_in "status_content", with: "http://google.com"
				mimic_spacebar("status_content")
				wait_for_link_fetch
				find(:xpath, "//input[@id='status_attached_url_image']").value.should eq ""
			end

			it "changes link img url if domain is not supplied" do
				# railscasts example already returns a relative img path
				find("img#1")['src'].should include "http://railscasts.com/"
			end

			it "uses full link image url when absolute url given" do
				find("a.clear-attached-link").click
				fill_in "status_content", with: "http://www.getflow.com"
				mimic_spacebar("status_content")
				wait_for_link_fetch
				find("img#1")['src'].should =~ /http:\/\//
				find("img#1")['src'].should =~ /flow/
				find("img#1")['src'].should =~ /jpg|png|jpeg/
			end

			it "changes #status_attached_url_image if img is changed" do
				find(:xpath, "//input[@id='status_attached_url_image']").value.should eq find("img#1")['src']
				find("a#next").click
				find(:xpath, "//input[@id='status_attached_url_image']").value.should eq find("img#2")['src']
			end

			it "removes information if link is x'd off" do
				find("a.clear-attached-link").click
				find(:xpath, "//input[@id='status_attached_url']").value.should eq ""
				find(:xpath, "//input[@id='status_attached_url_image']").value.should eq ""
				find(:xpath, "//input[@id='status_attached_url_description']").value.should eq ""
				find(:xpath, "//input[@id='status_attached_url_title']").value.should eq ""
			end
		end
	end
end