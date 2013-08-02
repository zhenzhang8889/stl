class SessionsController < Devise::SessionsController
  respond_to :js
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    sign_in(resource_name, resource)
  end

  def failure
    render
  end
end