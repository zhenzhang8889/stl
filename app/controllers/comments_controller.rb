class CommentsController < ApplicationController
	def create
		@comment = current_user.comments.create(params[:comment])
		@content = @comment.commentable
		notify!(@comment, @content.user, :comment_on_content, :site, :email)

		@content.comments.each do |c|
			unless c.user == @content.user
				notify!(@comment, c.user, :comment_on_same_content, :site, :email)
			end
		end

		respond_to do |format|
			if params[:from_feed].present?
				format.js { render "create_feed" }
			else
				format.js
			end
		end
	end

	def like
		@comment = Comment.find(params[:id])
		@like = @comment.likes.create!(:user_id => current_user.id)
		notify!(@like, @comment.user, :like_comment, :site, :email)

		respond_to do |format|
			format.html { redirect_to root_path, notice: 'You liked the comment'}
			format.js
		end
	end 

	# TODO: add notifications fix
	def unlike
		@comment = Comment.find(params[:id])
		@like = @comment.likes.where(:user_id => current_user.id).first
		@like.delete
		Comment.decrement_counter(:likes_count, @comment.id)

		respond_to do |format|
			format.html { redirect_to root_path, notice: 'You unliked the comment'}
			format.js
		end
	end
end