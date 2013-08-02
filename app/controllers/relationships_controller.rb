class RelationshipsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @user = User.find(params[:followed_id])
    @style = params[:style]
    @relationship = current_user.follow!(@user)
    notify!(@relationship, @user, :follow, :site, :email)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js { render template: "relationships/follow" }
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    @style = params[:style]
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js { render template: "relationships/follow" }
    end
  end
end