module NotificationsHelper
	def singular_content_name(object)
		object.class.table_name.singularize
	end

	def notification_count_color(unviewed)
		unviewed = unviewed.count

		if unviewed > 0
			"background: #DC6D00"
		end
	end

	def comment_on_content(n)
		link_to n.notifiable.commentable do
			"#{n.notifier.name} just commented on your #{singular_content_name(n.notifiable.commentable)}"
		end
	end

	def comment_on_same_content(n)
		link_to n.notifiable.commentable do
			"#{n.notifiable.user.name} commented on a #{singular_content_name(n.notifiable.commentable)} you commented on"
		end
	end

	def like_comment(n)
		link_to n.notifiable.likeable.commentable do
			"#{n.notifiable.user.name} liked a comment you made on a #{singular_content_name(n.notifiable.likeable.commentable)}"
		end
	end

	def like_content(n)
		link_to n.notifiable.likeable do
			"#{n.notifiable.user.name} liked your #{singular_content_name(n.notifiable.likeable)}"
		end
  end

	def follow(n)
		link_to n.notifiable.follower do
			"#{n.notifiable.follower.name} followed you!"
		end
	end

	def follow_stack(n)
		link_to n.notifiable do
			"Your stack has a new follower!"
		end
	end

	def share(n)
		link_to n.notifiable do
			"#{n.notifiable.user.name} just shared a #{singular_content_name(n.notifiable)} with you"
		end
	end

	def compliment(n)
		link_to compliments_user_path(n.user) do
			"#{n.notifiable.motivator.name} just complimented you!"
		end
	end
end
