class ComplimentsController < ApplicationController
	before_filter :authenticate_user!

	def create
		@user = User.find(params[:user_id])
		@compliment = @user.compliments.build(params[:compliment])
		if @compliment.save
			notify!(@compliment, @compliment.user, :compliment, :site, :email)
			redirect_to @user, :notice => "You just complimented #{@user.name}!"
		else	
			redirect_to :back, :alert => "Try that again - Make sure you enter a message"
		end
	end

	def compliment_modal
		@user = User.find(params[:user_id])
		respond_to do |format|
			format.js
		end
	end
end
