module FeedsHelper
	def likes_count_helper(c, options={})
		like_count = (content_tag(:i, "", class: " icon-thumbs-up") + " " + pluralize(c.likes_count, 'like'))
		if c.likes_count < 1
			link_to "javascript:void(0)", class: options[:style] do
				like_count
			end
    else
     link_to "javascript:void(0)", rel: "tooltip", data: { placement: "right", original_title: likes_tooltip_helper(c) }, class: options[:style] do
     	like_count
     end
   end
	end

	def likes_tooltip_helper(c)
		content = c
		count = c.likes_count
		likes = c.likes
		i_like = current_user.already_likes_this?(c) ? "You" : ""
		all_others = likes.collect { |l| l.user.name + "<br />" unless l.user == current_user }

		if i_like.blank? && all_others.blank?
			""
		elsif i_like.present? && all_others.blank?
			"You"
		elsif i_like.blank? && (all_others.split(", ").count == 1)
			all_others.join(" ")
		else
			i_like + "<br />" + all_others.join(" ")
		end
	end

	def for_discover(&block)
		block.call if on_path?("feeds", "discover")
	end

	def for_dashboard(&block)
		block.call if on_path?("feeds", "index")
	end

	def for_stacks_index(&block)
		block.call if on_path?("stacks", "index")
	end

	def for_stacks_show(&block)
		block.call if on_path?("stacks", "show")
	end

	def for_profile(&block)
		block.call if on_path?("users", "show")
	end

	def for_users_network(&block)
		block.call if on_path?("users", "network")
	end

	def for_users_edit(&block)
		block.call if on_path?("users", "settings") || on_path?("registrations", "update")
	end
	
	def for_service(&block)
	  block.call if on_path?("services", "index")
	end
	def for_notification(&block)
    block.call if on_path?("users", "notification")
  end
  
  def for_messages(&block)
    block.call if on_path?("users", "messages")
  end
end
