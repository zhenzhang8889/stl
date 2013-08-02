class StatusesController < ApplicationController
  include Stacked, Shared
  require 'nokogiri'
  require 'open-uri'
  require 'uri/http'

  before_filter :authenticate_user!, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy
  
  def search_url
    @url = params[:url]
    uri = URI.parse(@url)

    if uri.scheme == nil
      uri = URI.parse("http://" + uri.to_s)
      @url = uri.to_s
    end

    @domain = uri.scheme + '://' + uri.host

    doc = Nokogiri::HTML(open(@url))

    web_title = doc.xpath("//title").text.to_s

    if doc.xpath("//meta[@name='description']/@content").first != nil
      web_desc = doc.xpath("//meta[@name='description']/@content").first.value.to_s
      web_desc = web_desc[0..100] # Limit description to 140 characters.
      web_desc << "..."
    end

    web_images = doc.css('img').map{ |i| i['src'] }

    if doc.xpath("//meta[@property='og:image']/@content").first != nil
      web_images << doc.xpath("//meta[@property='og:image']/@content").first.value.to_s
    end

    # ensure only certain formats
    allowed_formats = ["jpg", "png", "jpeg", "JPG", "PNG", "JPEG"]
    web_images.delete_if do |img|
      !allowed_formats.include? img[-3..-1]
    end

    # ensure there is a full url to the image
    web_images.collect! do |img|
      case URI.parse(img).host
        when nil
          if img.split("").first == '/'
            @domain + img
          else
            @domain + '/' + img
          end
        else
          img
      end
    end

    @web_result = Hash.new
    @web_result['title'] = web_title
    @web_result['description'] = web_desc
    @web_result['images'] = web_images
    @web_result['total_images'] = web_images.count
    @web_result['full_url'] = @url

    respond_to do |format|
      format.json {render :json => @web_result}
    end
  end

  def index
    if params[:tag]
      @statuses = Status.tagged_with(params[:tag])
    end
  end

  def show
    @status = Status.find(params[:id])
    @comments = @status.comments.order(
                "created_at DESC").paginate(page: params[:page]).per_page(4)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @status = current_user.statuses.build(params[:status])

    respond_to do |format|
      if @status.save
        format.html { redirect_to root_path, notice: "Status Successfully Created"}
        format.js { render :js => "window.location.replace('#{root_path}');"}
      else
        format.html { redirect_to root_path, alert: "#{@status.errors.full_messages.to_sentence}"}
        format.json { render json: @status.errors, status: :unprocessable_entity }
        format.js { render 'errors' }
      end
    end
  end


  def destroy
    @status = Status.find(params[:id])
    @status.feeds.first.delete
    StackedItem.where(:stackable_type => "Status", :stackable_id => @status.id).delete_all
    @status.delete
    redirect_to :back, notice: "Deleted"
  end

  def mini_workout_modal
    @status = current_user.statuses.build
    respond_to do |format|
      format.js
    end
  end

  def mini_workout
    @status = current_user.statuses.build(params[:status])

    if @status.save
      redirect_to root_path, notice: "Workout Saved"
    else
      redirect_to root_path, notice: "Something went wrong. #{@status.errors.full_messages.to_sentence}."
    end
  end

  def like
    @status = Status.find(params[:id])
    @like = @status.likes.create!(:user_id => current_user.id)
    notify!(@like, @status.user, :like_content, :site, :email)

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'You liked the post'}
      format.js
    end
  end 


  def unlike
    @status = Status.find(params[:id])
    Status.decrement_counter(:likes_count, @status.id)
    @like = @status.likes.where(:user_id => current_user.id).first
    @like.delete
    

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'You unliked the post'}
      format.js
    end
  end

  private
    def correct_user
      @status = current_user.statuses.find_by_id(params[:id])
      redirect_to root_url if @status.nil?
    end
end