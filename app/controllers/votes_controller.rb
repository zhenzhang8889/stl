class VotesController < ApplicationController
  
  def create

  	#@post = Post.find(params[:post_id])
	#@post.votes.create

	target = Vote.find_by_resource_id(params[:resource_id])
	current_user.vote! target
	redirect_to :back, :notice => "success"
	respond_to do |format|
	format.html { redirect_to @story }
	format.js
end
  end
end
