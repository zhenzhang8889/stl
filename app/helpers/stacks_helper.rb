module StacksHelper
  def link_to_follow_stack(stack)
    if stack.followed_by?(current_user)
      link_to unfollow_stack_path(stack), method: :put, remote: true do
        content_tag(:i, '', class: "icon-reply") + "Unfollow"
      end
    else
      link_to follow_stack_path(stack), method: :post, remote: true do
        content_tag(:i, '', class: "icon-reply") + "Follow"
      end
    end
  end

  def link_to_like_stack(stack)
    if current_user.already_likes_this?(stack)
      link_to unlike_stack_path(stack), method: :delete, remote: true do
        content_tag(:i, '', class: "icon-heart") + ' ' + "Unlike"
      end
    else
      link_to like_stack_path(stack), method: :post, remote: true do
        content_tag(:i, '', class: "icon-heart") + ' ' + "Like"
      end
    end
  end

  def stack_owner_tools(stack, &block)
    block.call if current_user.owns(stack)
  end
end