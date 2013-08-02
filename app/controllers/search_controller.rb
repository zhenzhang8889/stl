class SearchController < ApplicationController
  def index
    @posts = get_posts    
    @exercises = get_exercises
    @workouts = get_workouts    
  end
  
private
  def get_posts
    if params[:search_keyword]
      Feed.search_posts( params[:search_keyword] )
    end
  end
  
  def get_exercises
    if params[:search_keyword]
      Feed.search_statuses( params[:search_keyword] )
    end
  end
  
  def get_workouts
    if params[:search_keyword]
      Feed.search_workouts( params[:search_keyword] )
    end
  end
end
