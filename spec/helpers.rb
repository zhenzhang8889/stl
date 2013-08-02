module Helpers
	def wait_for_link_fetch
		wait_until { !page.find("#link-loading").visible? }
		rescue Capybara::TimeoutError
		  flunk 'Ajax timed out'
	end

	def mimic_spacebar(element)
		page.find_by_id(element).native.send_keys :space
	end

	def mimic_return(element)
		page.find_by_id(element).native.send_keys :enter
	end

	def wait_for_ajax(timeout = Capybara.default_wait_time)
		page.wait_until(timeout) do
			page.evaluate_script 'jQuery.active == 0'
		end
	end

	def wait_for_dom(timeout = Capybara.default_wait_time)
		uuid = SecureRandom.uuid
		page.find("body")
		page.evaluate_script <<-EOS
			_.defer(function() {
			  $('body').append("<div id='#{uuid}'></div>");
			});
		EOS
		page.find("##{uuid}")
	end
end