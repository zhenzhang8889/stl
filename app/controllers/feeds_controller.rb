class FeedsController < ApplicationController
	before_filter :authenticate_user!, only: [:like, :unlike]
	def index
		@status  = current_user.statuses.build
		@user = current_user
		@feed_items = Feed.from_users_followed_by(current_user).order(
		        		"created_at DESC").paginate(page: params[:page])

		if @feed_items.count < 1
			@feed_items = Feed.discover_content('popular', current_user).take(30)
		end
	end

	def filter_activity
		filter_content = params[:feed_filter][:content].split(",")
		filter_content.collect! { |c| c.capitalize! }
		type = params[:feed_filter][:type]
		tag = params[:feed_filter][:tag]
		@search = params[:feed_filter][:search]
		if @search.present?
			@searches = Feed.search_posts(@search) + Feed.search_statuses(@search) + Feed.search_workouts(@search)
			@results = Feed.where(:id => @searches.map(&:id)).filter_content_type(filter_content).order("created_at DESC").paginate(page: params[:page])
		end
		
		@feed_items = Feed.from_users_followed_by(current_user, type: type, tag: tag, search: @search).filter_content_type(filter_content).order(
		        		"created_at DESC").paginate(page: params[:page])
		respond_to do |format|
			format.js
		end
	end

	def filter_discover
		filter_content = params[:feed_filter][:content].split(",")
		filter_content.collect! { |c| c.capitalize! }
		type = params[:feed_filter][:type]

		@feed_items = Feed.filter_content_type(filter_content).discover_content(type, current_user).take(30)

		respond_to do |format|
			format.js
		end
	end

	def discover
		@status  = current_user.statuses.build
		@user = current_user
		@feed_items = Feed.discover_content('recommended', current_user).order(
		        		"created_at DESC").paginate(page: params[:page])
	end

	def popular
		@feed_items = Feed.discover_content('popular', current_user).take(30)


		respond_to do |format|
			format.js
		end
	end

	def recommended
		@feed_items = Feed.discover_content('recommended', current_user).order(
		        		"created_at DESC").paginate(page: params[:page])
		respond_to do |format|
			format.js
		end
	end

	def featured
		@feed_items = Feed.discover_content('featured', current_user).order(
		        		"created_at DESC").paginate(page: params[:page])

		respond_to do |format|
			format.js
		end
	end


	def tags
		if params[:tag]
			@feed_items = Feed.from_users_followed_by(current_user).order(
			        		"created_at DESC").paginate(page: params[:page]).tagged_with(params[:tag])
		else
			redirect_to root_path, notice: "Something went wrong."
		end
	end

	def like
		@feed_item = Feed.find(params[:id])
		@content = @feed_item.feedable
		@like = @content.likes.create!(:user_id => current_user.id)
		notify!(@like, @content.user, :like_content, :site, :email)

		respond_to do |format|
			format.html { redirect_to root_path, notice: 'You liked the post'}
			format.js
		end
	end 

	# TODO: fix notifications unlike
	def unlike
		@feed_item = Feed.find(params[:id])
		@content = @feed_item.feedable
		klass = @content.class.table_name.singularize.capitalize.constantize
		klass.decrement_counter(:likes_count, @content.id)
		@like = @content.likes.where(:user_id => current_user.id).first
		@like.delete
		

		respond_to do |format|
			format.html { redirect_to root_path, notice: 'You unliked the post'}
			format.js
		end
	end
end
