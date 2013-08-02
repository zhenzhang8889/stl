class MessagesController < ApplicationController    
    def send_to
      body = params[:body]
      subject = params[:subject]      
      reciever  = params[:recipients]      
       
      message = Message.new
      message.subject = subject
      message.body = body
      message.sender_id = sender_id
      message.recipient_id = reciever.to_i
      message.save
      
      @users = User.all     
      @recieved_messages = current_user.received_messages
      @sent_messages = current_user.sent_messages
      
      respond_to do |format|  
        format.html    
        format.js
      end
    end
    
    def compose
      body = params[:body]
      recipients = params[:recipients]      
      
      reciever = User.find_by_username(recipients)
      unless reciever == nil
        id = reciever.id      
        message = Message.new
        message.subject = "New message"
        message.body = body
        message.sender_id = sender_id
        message.recipient_id = id.to_i
        message.save
        
        respond_to do |format|  
          format.html    
          format.js
        end
     end
    end
private
    def sender_id
      current_user.id.to_i
    end    
end
