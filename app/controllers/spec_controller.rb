class SpecController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy


def index

	redirect_to :controller => "user", :action => "index"
end
# Edit the user's spec.
def edit
	    @title = "Edit Spec"
	    @user = User.find(session[:user_id])
	    @user.spec ||= Spec.new
	    @spec = @user.spec
	    if param_posted?(:spec)
	    	if @user.spec.update_attributes(params[:spec])
	    		flash[:notice] = "Changes saved."
	    		redirect_to :controller => "user", :action => "index"
	    	end
	    end

end
end
