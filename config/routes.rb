SampleApp::Application.routes.draw do  

  get "feedback/index"

  get "feedback/send_msg"

  get "search/index"
  get "messages/send_to"
  get "messages/compose"
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks", 
                                    registrations: "registrations", 
                                    :sessions => 'sessions' 
                                  }
                                  
  get "users/network", to: "users#network"
  resources :users do
    member do
      get :following, :followers, :compliments, :thankings, :notifications
      put :add_interest
    end
    collection do
      get :posts
      get :surpassed
      get :stacks
      get :about
      get :network_following
      get :network_followers
      get :profile_settings
      get :notification_settings
      get :user_settings
      get :settings
      get :notification
      get :message
      get :sort_network
      get :set_recipient
      get :popular_network
      get :services
      get :messages
      get :send_message
    end
  end
  
  get 'tags/:tag', to: 'posts#index', as: :tag
  get 'tags/:tag', to: 'statuses#index', as: :tag
  get 'tags/:tag', to: 'workouts#index', as: :tag
  get 'tags/:tag', to: 'services#index', as: :tag

  get "status_search_url" => "statuses#search_url", :as => 'status_search_url'
  put "/notifications/viewed" => "notifications#viewed"
  
  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/search_goal', to: 'static_pages#search_goal'
  match '/search_more', to: 'static_pages#search_more'
  match '/connect', to: 'static_pages#connect'
  match '/interests', to: 'static_pages#interests'
  match '/follow', to: 'static_pages#follow'
  match '/notification',    to: 'users#notification'
  resources :services do
    collection do
      get "services/new"      
      get :share_modal    
    end
    
    member do
      post :like
      delete :unlike
      post :save_to_stacks
      put :share
    end
  end
  resources :posts do
    resources :votes
    member do
      post :like
      delete :unlike
      post :save_to_stacks
      put :share
    end
    collection do
      get :share_modal
    end
  end
  
  resources :compliments do
    collection do
      get :compliment_modal
    end
  end
  resources :stacks do
    member do
      post :follow
      put :unfollow
      post :like
      delete :unlike
      put :share
    end
    collection do
      get :popular
      get :following
      get :save_modal
      get :items
      get :comments
      get :share_modal
    end
  end
  resources :statuses do
    member do
      post :like
      delete :unlike
      post :save_to_stacks
      put :share
    end
    collection do
      get :share_modal
      get :mini_workout_modal
      post :mini_workout
    end
  end
  resources :groups
  resources :goals
  resources :workouts do
    member do
      post :like
      delete :unlike
      post :save_to_stacks
      put :share
    end
    collection do
      get :share_modal
    end
  end
  resources :exercises, only: [:destroy]
  resources :events
  resources :statuses, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :thankings, only: [:create]
  resources :feeds do
    member do
      post :like
      delete :unlike
    end
    collection do
      get :tags
      get :discover
      get :recommended
      get :popular
      get :featured
      get :filter_activity
      get :filter_discover
    end
  end
  resources :comments do
    member do
      post :like
      delete :unlike
    end
  end

  resources :after_signup
  
  root :to => "feeds#index", :constraints => lambda{ |req| req.session['warden.user.user.key'].present? }
  root :to => 'static_pages#home'

  get "/:id", :to => "users#show", :as => :user  
end
