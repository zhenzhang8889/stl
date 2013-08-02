class FeedbackController < ApplicationController  
  def send_msg
    from = params[:from]
    name = params[:name]
    contents = params[:contents]
    FeedbackMailer.feedback(from, name, contents).deliver
    render :layout => false    
  end  
end
