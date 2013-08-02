class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  # REFACTOR: slow - use a javascript solution
  before_filter :check_notification_validity

  helper_method :resource, :resource_name

  def check_notification_validity
    if signed_in?
      Notification.check_validity(current_user)
    end
  end

	def param_posted?(sym)
		request.post? and params[sym]
	end

	def notify!(resource, user, behaviour, *methods)
		Notification.delay.create_and_delegate(current_user, resource, user, behaviour, methods) unless user == current_user
	end

  def resource
    instance_variable_get(:"@user")
  end

  # Proxy to devise map name
  def resource_name
    :user
  end

  def after_sign_in_path_for(resource)
    "/after_signup"
  end
end