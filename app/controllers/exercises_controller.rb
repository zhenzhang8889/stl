class ExercisesController < ApplicationController
	before_filter :authenticate_user!

	def destroy
		@exercise = Exercise.find(params[:id])
		@exercise.delete
		respond_to do |format|
			format.js
		end
	end
end
