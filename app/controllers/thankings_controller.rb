class ThankingsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :not_current_user

  def create
  	@thanked = User.find(params[:user_id])
  	@thanking = @thanked.thanks.build(params[:thanking])
    respond_to do |format|
      if @thanking.save
      	@resource = @thanking.resource_object
      	notify!(@thanking, @thanked.email, @thanked)
      	format.html { redirect_to :back, :notice => "You just thanked #{@thanked.name}" }
        format.js
      else
        format.html { redirect_to :back, :alert => "You can't double thank" }
        format.js
      end
    end
  end

private
	def not_current_user
		if User.find(params[:user_id]) != current_user
		else
			redirect_to :back, :alert => "You can't thank yourself"
		end
	end
end
