class StacksController < ApplicationController
  include Shared
  
  def index
    if signed_in?
      @user = current_user
      @following = @user.following_by_type('Stack').order(
                  "created_at DESC")
    else
      @popular = Stack.all.sort_by(&:followers_count).reverse
    end
  end

  ### Show Page Actions
  def show
    @stack = Stack.find(params[:id])
    @followers = @stack.followers.take(9)
    @items = @stack.stacked_items.order(
                "created_at DESC")

    respond_to do |format|
      format.html
      format.js
    end
  end

  def items
    @stack = Stack.find(params[:id])
    @items = @stack.stacked_items.order(
                "created_at DESC")
    respond_to do |format|
      format.js
    end
  end

  def comments
    @stack = Stack.find(params[:id])
    @comments = @stack.comments.order(
                "created_at DESC").paginate(page: params[:page]).per_page(4)
    respond_to do |format|
      if params[:page]
        format.js { render "comment-list" }
      else
        format.js
      end
    end
  end
  ### end show page actions

  def new
    @stack = current_user.stacks.new
  end

  def create
    @stack = current_user.stacks.build(params[:stack])
    if params[:from_modal]
      klass = params[:stack][:stacked_items_attributes][:"0"][:stackable_type].constantize
      @content = klass.find(params[:stack][:stacked_items_attributes][:"0"][:stackable_id])
    end
    respond_to do |format|
      if @stack.save
        @stack.user.follow(@stack)
        format.html { redirect_to @stack }
        format.js { render partial: "stacks/save_modal_success", locals: { stack: @stack } }
      else
        format.html { render :new }
        format.json { render json: @stack.errors, status: :unprocessable_entity }
        format.js { render partial: "stacks/modal_new_error" }
      end
    end
  end

  def edit
    @stack = Stack.find(params[:id])
  end

  def update
    @stack = Stack.find(params[:id])

    if @stack.update_attributes(params[:stack])
      redirect_to @stack
    else
      render :edit
    end
  end

  def destroy
    @stack = Stack.find(params[:id])
    @stack.delete
    redirect_to stacks_path, notice: "Stack Deleted"
  end

  def save_modal
    klass = params[:c_type].constantize
    @content = klass.find(params[:c_id])
    respond_to do |format|
      format.js
    end
  end

  def popular
    @popular = Stack.all.sort_by(&:followers_count).reverse
  end

  def following
    @user = current_user
    @following = @user.following_by_type('Stack').order(
                "created_at DESC")
  end

  def follow
    @user = current_user
    @stack = Stack.find(params[:id])
    @user.follow(@stack)
    notify!(@stack, @stack.user, :follow_stack, :site, :email)
    respond_to do |format|
      format.js { render partial: "follow" }
    end
  end

  def unfollow
    @user = current_user
    @stack = Stack.find(params[:id])
    @user.stop_following(@stack)
    respond_to do |format|
      format.js { render partial: "follow" }
    end
  end

  def like
    @stack = Stack.find(params[:id])
    @like = @stack.likes.create!(:user_id => current_user.id)
    notify!(@like, @stack.user, :like_content, :site, :email)

    respond_to do |format|
      format.html { redirect_to @stack, notice: 'You liked this stack'}
      format.js { render partial: "like" }
    end
  end 

  # TODO: add notification fix
  def unlike
    @stack = Stack.find(params[:id])
    Stack.decrement_counter(:likes_count, @stack.id)
    @like = @stack.likes.where(:user_id => current_user.id).first
    @like.delete

    respond_to do |format|
      format.html { redirect_to @stack, notice: 'You unliked this stack'}
      format.js { render partial: "like" }
    end
  end
end