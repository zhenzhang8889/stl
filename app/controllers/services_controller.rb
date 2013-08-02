class ServicesController < ApplicationController
  include Stacked, Shared
  def index
    @user = current_user
    @feed_items = Feed.where('feedable_type' => 'Service').order(
                "created_at DESC").paginate(page: params[:page])
  end

  def show
    @service = Service.find(params[:id])    
    @comments = @service.comments.order(
                "created_at DESC").paginate(page: params[:page]).per_page(4)
     
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @service }
      format.js
    end
  end
  
  def new
    @service = Service.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @service } 
    end
  end
  
  # POST /workouts
  # POST /workouts.json
  def create
    @service = current_user.services.build(params[:service])
    respond_to do |format|
      if @service.save
        format.html { redirect_to @service, notice: 'Service was successfully created.' }
        format.json { render json: @service, status: :created, location: @service }
        format.js { render :js => "window.location.replace('#{service_url(@service)}');"}
      else
        format.html { render action: "new" }
        format.json { render json: @service.errors, status: :unprocessable_entity }
        format.js { render 'errors' }
      end
    end
  end
  
  def like
    @service = Service.find(params[:id])
    @like = @service.likes.create!(:user_id => current_user.id)
    notify!(@like, @service.user, :like_content, :site, :email)

    respond_to do |format|
      format.html { redirect_to @service, notice: 'You liked the post'}
      format.js
    end
  end 

   def post_comment
    @comment = Comment.new(params[:comment])
    @comment.post_id = params[:id].to_i
    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_path(params[:id]), notice: 'comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { redirect_to post_path(params[:id]), notice: 'Please provide a comment'}
      end
    end
  end
  
  def unlike
    @service = Service.find(params[:id])
    Post.decrement_counter(:likes_count, @service.id)
    @like = @service.likes.where(:user_id => current_user.id).first
    @like.delete
    

    respond_to do |format|
      format.html { redirect_to @service, notice: 'You unliked the post'}
      format.js
    end
  end
end