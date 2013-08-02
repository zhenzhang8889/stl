module ServicesHelper
   def dollar_price(price)
     "$" + price.to_s
   end
   
   def shared_service(date)
     "Shared " + time_ago_in_words( date )
   end
   
   def created_service(date)
     "Created " + time_ago_in_words(date)
   end
   
   def spot_left(spot)
     if spot > 1
       spot.to_s + " Spots Left"
     else
       spot.to_s + "Spot Left"
     end
   end
   
   def remaining ( date )
     diff = (date.to_date - Time.zone.now.to_date ).to_i
     
     if diff < 0
       "Expired"
     elsif diff == 1
       diff.to_s + " Day Remaining"
     else
        diff.to_s + " Days Remaining"
     end
   end
   
   def follow_counts ( follow )
    if follow == 1
        follow.to_s + " Follower"
    else
        follow.to_s + " Followers"
    end
   end
   
   def post_counts( post )
    if post == 1
      post.to_s + " Post"
    else
      post.to_s + " Posts"
    end
   end
end
