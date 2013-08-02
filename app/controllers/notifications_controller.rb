class NotificationsController < ApplicationController
	def viewed
		@notifications = Notification.find(params[:ids].split(","))
		@notifications.each { |n| n.toggle!(:viewed) }
		respond_to do |format|
			format.js
		end
	end
end
