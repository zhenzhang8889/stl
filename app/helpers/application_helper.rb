module ApplicationHelper 
  def render_feed_item_for(item)    
    case
      when item.is_a_post?
        render "shared/feed/post_view", post: item.feedable, feed: item
      when item.is_a_workout?
        render "shared/feed/workout_view", workout: item.feedable, feed: item
      when item.is_a_status?
        render "shared/feed/status_view", status: item.feedable, feed: item
      when item.is_a_service?
        render "shared/feed/service_view", service: item.feedable, feed: item
    end
  end
  
  def tag_links(content)
    # raw content.tags.map(&:name).map { |t| link_to t, tags_feeds_path(tag: t), :class => "tag"}.join(' ')

    tags = ""
    content.tags.each do |t|
      tags += link_to tags_feeds_path(tag: t), :class => "tag" do
        content_tag(:i, '', class: "icon-tag") + " " + t.name
      end
    end
    return raw tags
  end

  def link_to_notification_story(n)
    begin
      link_to n.user_story, n.story_link
    rescue
      ## user unliked and therefore story no longer exists
      n.delete
    end
  end

  def link_to_like_feed(feed, content)
    if current_user.already_likes_this?(content)
      link_to unlike_feed_path(feed), method: :delete, remote: true, class: "like_feed_item_#{feed.id}" do
        content_tag(:i, '', class: "icon-heart") + " " + "Unlike"
      end
    else
      link_to like_feed_path(feed), method: :post, remote: true, class: "like_feed_item_#{feed.id}" do
        content_tag(:i, '', class: "icon-heart") + " " + "Like"
      end
    end
  end

  def link_to_like_status_show(content)
    if current_user.already_likes_this?(content)
      link_to unlike_status_path(content), method: :delete, remote: true, class: "btn" do
        content_tag(:i, '', class: "icon-heart") + ' ' + "Unlike"
      end
    else
      link_to like_status_path(content), method: :post, remote: true, class: "btn" do
        content_tag(:i, '', class: "icon-heart") + ' ' + "Like"
      end
    end
  end
       
  def link_to_like_service_show(content)
    if current_user.already_likes_this?(content)
      link_to unlike_service_path(content), method: :delete, remote: true, class: "btn" do
        content_tag(:i, '', class: "icon-heart") + ' ' + "Unlike"
      end
    else
      link_to like_service_path(content), method: :post, remote: true, class: "btn" do
        content_tag(:i, '', class: "icon-heart") + ' ' + "Like"
      end
    end
  end
  def link_to_like_post_show(content)
    if current_user.already_likes_this?(content)
      link_to unlike_post_path(content), method: :delete, remote: true, class: "btn" do
        content_tag(:i, '', class: "icon-heart") + ' ' + "Unlike"
      end
    else
      link_to like_post_path(content), method: :post, remote: true, class: "btn" do
        content_tag(:i, '', class: "icon-heart") + ' ' + "Like"
      end
    end
  end

  def link_to_like_workout_show(content)
    if current_user.already_likes_this?(content)
      link_to unlike_workout_path(content), method: :delete, remote: true, class: "btn" do
        content_tag(:i, '', class: "icon-heart") + ' ' + "Unlike"
      end
    else
      link_to like_workout_path(content), method: :post, remote: true, class: "btn" do
        content_tag(:i, '', class: "icon-heart") + ' ' + "Like"
      end
    end
  end


  def link_to_like_comment(comment)
    if current_user.already_likes_this?(comment)
      link_to unlike_comment_path(comment), method: :delete, remote: true, class: "like" do
        content_tag(:i, '', class: "icon-heart") + "Unlike"
      end
    else
      link_to like_comment_path(comment), method: :post, remote: true, class: "like" do
        content_tag(:i, '', class: "icon-heart") + "Like"
      end
    end
  end

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Surpass the Limit"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render('workouts/' + association.to_s.singularize + "_fields", f: builder)
    end
    link_to '#', class: "add_fields orange_button pull-left", data: {id: id, fields: fields.gsub("\n", "")} do
      content_tag(:i, '', class: "icon-plus-sign") + name
    end
  end

  def link_to_remove_exercise_instance(exercise)
    if exercise.new_record?
      link_to "javascript:void(0);", class: "remove-exercise orange_button small pull-right" do
        content_tag(:i, '', class: "icon-trash")
      end
    else
      link_to exercise_path(exercise), method: :delete, remote: true, class: "remove-exercise-#{exercise.id} orange_button small pull-right" do
        content_tag(:i, '', class: "icon-trash")
      end
    end
  end

  def on_path?(r_controller, action)
    controller.controller_name == r_controller && controller.action_name == action
  end
  
  # helper.from_path?("/users/show", "http://0.0.0.0:3000/posts/316-klj")
  def from_path?(path, from)
    begin 
      case
      when path.split("/").last == "show"
        request = URI(from).path
        path_controller = path.split("/")[1]
        request_controller = request.split("/")[1]
        request_last = request.split("/").last

        true if path_controller == request_controller && (Float(request_last) rescue false)
      else 
        path == URI(from).path ? true : false
      end
    rescue
      false
    end
  end

  # REFACTOR: clash of show and feed on a show (tabs)
  def comment_success_from_stack(content, &block)
    block.call if from_path?("/stacks/show", request.referer)
  end

  def on_comments
    on_path?("comments", "create")
  end
  
  
     
  def from_a_feed_path
    from_path?("/", request.referer) || \
    from_path?("/users/show", request.referer) || \
    from_path?("/stacks/show", request.referer) || \
    from_path?("/feeds/tags", request.referer)
  end
end
