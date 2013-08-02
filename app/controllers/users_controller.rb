class UsersController < ApplicationController
  def index
  	@users = User.paginate(page: params[:page])
    @compliment = Compliment.new
  end

  def show
  	@user = User.find_by_username(params[:id])
    @feed_items = Feed.where('user_id' => @user.id).order(
                "created_at DESC").paginate(page: params[:page])
    @compliment = Compliment.new
  end
  
  def services
    @user = User.find(params[:user])
    @feed_items = Feed.where('user_id' => @user.id).order(
                "created_at DESC").paginate(page: params[:page])
    respond_to do |format|
      format.js
    end  
  end
  def user_notification
    @user = current_user
    respond_to do |format|
      format.js
    end
  end
  
  def posts
    @user = User.find(params[:user])
    @feed_items = Feed.where('user_id' => @user.id).order(
                "created_at DESC").paginate(page: params[:page])
    respond_to do |format|
      format.js
    end
  end

  def add_interest
    @user = current_user
    current_interests = @user.interest_list || Array.new
    @new_interest = params[:user][:interest]
    new_list = current_interests << @new_interest
    @user.update_attribute(:interest_list, new_list)
    respond_to do |format|
      format.js
    end
  end
  def set_recipient
    @id = params[:id]
    respond_to do |format|
      format.js
    end
  end
  
  def messages
    @users = User.all
    @recieved_messages = current_user.received_messages
    @sent_messages = current_user.sent_messages
    
    @recieved_messages.each do |message|
      unless message.message_read?      
        message.read_at = Time.now
        message.save
      end
    end
  end
  
  def sort_network
    topic = params[:topic]

    case topic
    when "all"
      @network = User.order("followers_count DESC").paginate(page: params[:page]).per_page(50)
    else
      @network = User.order("followers_count DESC").tagged_with(topic.downcase, on: :interests)
    end

    respond_to do |format|
      format.js
    end
  end

  def surpassed
    respond_to do |format|
      format.js
    end
  end

  def stacks
    @user = User.find(params[:user])
    respond_to do |format|
      format.js
    end
  end

  def settings
    @user = current_user
  end

  def profile_settings
    @user = current_user
    
    respond_to do |format|
      format.js
    end
  end

  def notification_settings
    respond_to do |format|
      format.js
    end
  end

  def user_settings
    @user = current_user
    respond_to do |format|
      format.js
    end
  end

  def about
    @user = User.find(params[:user])
    @abouts = [:goals, :interest_list, :skill_list, :bio]
    @abouts.delete_if { |x| @user.send(x).blank? }
    respond_to do |format|
      format.js
    end
  end

  def compliments
    @user = User.find_by_username(params[:id])
    redirect_to root_path, alert: "Not Authorized" unless @user == current_user
    @compliments = @user.compliments.paginate(page: params[:page]).per_page(10)
  end
  
  def send_message
    body = params[:body]
    subject = params[:subject]      
    reciever  = params[:recipients]      
     
    message = Message.new
    message.subject = subject
    message.body = body
    message.sender_id = sender_id
    message.recipient_id = reciever.to_i
    message.save
    @all_message = Message.all
    @users = User.all     
    @recieved_messages = current_user.received_messages
    @sent_messages = current_user.sent_messages
    
    respond_to do |format|   
      format.js
    end
  end
  
  def message    
    @users = User.all     
    @recieved_messages = current_user.received_messages
    @sent_messages = current_user.sent_messages
     
    respond_to do |format|
      format.js     
    end
  end
    
  def notifications
    @user = User.find_by_username(params[:id])
    redirect_to root_path, alert: "Not Authorized" unless @user == current_user
    @notifications = @user.notifications.for_site.order(
                "created_at DESC").paginate(page: params[:page]).per_page(10)
  end

  def network
    @network = User.order("followers_count DESC").paginate(page: params[:page]).per_page(50)
  end

  def popular_network
    @network = User.order("followers_count DESC").paginate(page: params[:page]).per_page(50)
  end

  def network_followers
    @followers = current_user.followers
    respond_to do |format|
      format.js
    end
  end

  def network_following
    @following = current_user.followed_users
    respond_to do |format|
      format.js
    end
  end

  def thankings
    @user = User.find_by_username(params[:id])
    @thankings = @user.thanks
  end

  def following
    @title = "Following"
    @user = User.find_by_username(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find_by_username(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
private
    def sender_id
      current_user.id.to_i
    end    
end
