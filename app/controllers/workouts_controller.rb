class WorkoutsController < ApplicationController
  include Stacked, Shared
  # GET /workouts
  # GET /workouts.json
  def index
    if params[:tag]
      @workouts = Workout.tagged_with(params[:tag])
    else
    @workouts = Workout.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @workouts }
    end
  end
end

  # GET /workouts/1
  # GET /workouts/1.json
  def show
    @workout = Workout.find(params[:id])
    @thanking = @workout.user.thanks.build
    @comments = @workout.comments.order(
                "created_at DESC").paginate(page: params[:page]).per_page(4)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @workout }
      format.js
    end
  end

  # GET /workouts/new
  # GET /workouts/new.json
  def new
    @workout = Workout.new
    # @workout.exercises.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @workout }
    end
  end

  # GET /workouts/1/edit
  def edit
    @workout = Workout.find(params[:id])
  end

  # POST /workouts
  # POST /workouts.json
  def create
    @workout = current_user.workouts.build(params[:workout])
    respond_to do |format|
      if @workout.save
        format.html { redirect_to @workout, notice: 'workout was successfully created.' }
        format.json { render json: @workout, status: :created, location: @workout }
        format.js { render :js => "window.location.replace('#{workout_url(@workout)}');"}
      else
        format.html { render action: "new" }
        format.json { render json: @workout.errors, status: :unprocessable_entity }
        format.js { render 'errors' }
      end
    end
  end

  # PUT /workouts/1
  # PUT /workouts/1.json
  def update
    @workout = Workout.find(params[:id])

    respond_to do |format|
      if @workout.update_attributes(params[:workout])
        format.html { redirect_to @workout, notice: 'workout was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @workout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workouts/1
  # DELETE /workouts/1.json
  def destroy
    @workout = Workout.find(params[:id])
    @workout.feeds.first.delete
    StackedItem.where(:stackable_type => "Workout", :stackable_id => @workout.id).delete_all
    @workout.destroy

    respond_to do |format|
      format.html { redirect_to :back, notice: "Deleted" }
      format.json { head :no_content }
    end
  end
  
  def workout_comment
    @comment = Comment.new(params[:comment])
    @comment.workout_id = params[:id].to_i
    respond_to do |format|
      if @comment.save
        format.html { redirect_to workout_path(params[:id]), notice: 'comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { redirect_to workout_path(params[:id]), notice: 'Please provide a comment'}
      end
    end
  end
  
  def like
    @workout = Workout.find(params[:id])
    @like = @workout.likes.create!(:user_id => current_user.id)
    notify!(@like, @workout.user, :like_content, :site, :email)

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'You liked the post'}
      format.js
    end
  end 

  # TODO: add notification fix
  def unlike
    @workout = Workout.find(params[:id])
    Workout.decrement_counter(:likes_count, @workout.id)
    @like = @workout.likes.where(:user_id => current_user.id).first
    @like.delete
    

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'You unliked the post'}
      format.js
    end
  end

  private

    def correct_user
      
      @workout = current_user.workouts.find_by_id(session[:id])
      redirect_to root_url if @workout.nil?
    end
end


