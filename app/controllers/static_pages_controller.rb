class StaticPagesController < ApplicationController
def home
    if signed_in?
      redirect_to feeds_path
    end
  end
  
  def help
    render
  end

  def about
    render
  end

  def contact
    render
  end
  
  def search_goal
    search_data
    render :layout => false
  end

  def search_more
    search_data
  end

  def connect
    render
  end

  def interests
    render
  end

  def follow
    @users = User.all
    render
  end

private

  def search_data
      search_keywords=params[:keyword_text].split('-')
      @articles=[]
      @exercises=[]
      @workouts=[]
      if search_keywords.include?('weight')
        add_to_objects(['lose weight', 'weightloss',  'diet'])
      end
      if search_keywords.include?('sport')
        add_to_objects(['sports'])
      end
      if search_keywords.include?('stronger')
         add_to_objects(['strength', 'bulking up', 'bulk up', 'tone up', 'weights', 'body building', 'ripped', 'muscle'])
      end
      if search_keywords.include?('healthy')
        add_to_objects(['healthy', 'healthy lifestyle', 'nutrition', 'diet'])
      end
      if search_keywords.include?('recover')
        add_to_objects(['recovery', 'therapy'])
      end
  end

  def add_to_objects(req_tags)
      @articles << Post.tagged_with(req_tags)
       @articles.flatten!
      @workouts << Workout.tagged_with(req_tags)
      @workouts.flatten!
      @exercises << @workouts.map(&:exercises)
      @exercises.flatten!
  end
end