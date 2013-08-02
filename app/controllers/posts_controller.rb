class PostsController < ApplicationController
  include Stacked, Shared
  # GET /posts
  # GET /posts.json
  def index
    if params[:tag]
    @posts = Post.tagged_with(params[:tag])
  else
    @posts = Post.all
  end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order(
                "created_at DESC").paginate(page: params[:page]).per_page(4)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
      format.js
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.build(params[:post])
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
        format.js { render :js => "window.location.replace('#{post_url(@post)}');"}
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
        format.js { render "errors" }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.feeds.first.delete
    StackedItem.where(:stackable_type => "Post", :stackable_id => @post.id).delete_all
    @post.destroy

    respond_to do |format|
      format.html { redirect_to :back, notice: "Deleted" }
      format.json { head :no_content }
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
  
  
  def like
    @post = Post.find(params[:id])
    @like = @post.likes.create!(:user_id => current_user.id)
    notify!(@like, @post.user, :like_content, :site, :email)

    respond_to do |format|
      format.html { redirect_to @post, notice: 'You liked the post'}
      format.js
    end
  end 


  def unlike
    @post = Post.find(params[:id])
    Post.decrement_counter(:likes_count, @post.id)
    @like = @post.likes.where(:user_id => current_user.id).first
    @like.delete
    

    respond_to do |format|
      format.html { redirect_to @post, notice: 'You unliked the post'}
      format.js
    end
  end
     
   
    
  private

    def correct_user
      @post = current_user.posts.find_by_id(session[:id])
      redirect_to root_url if @post.nil?
    end
end


