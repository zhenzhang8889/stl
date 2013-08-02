module MessagesHelper
   def unread
    current_user.unread_message_count
   end
    
end
