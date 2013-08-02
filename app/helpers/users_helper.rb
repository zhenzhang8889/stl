module UsersHelper
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def profile_image_for(user, size)
  	if user.images.present?
  		image_tag(user.images.last.item.url(:thumb), alt: user.name, class: "gravatar", width: size, height: size)
  	elsif user.authentications.present?
      social = grab_social_source(user)
      image_tag(social.image, alt: user.name, class: "gravatar", width: size, height: size)
  	else
  		gravatar_for user, size: size
  	end
  end
  
  
  def grab_social_source(user)
    if user.has_auth?(:facebook)
      user.auth(:facebook)
    elsif user.has_auth?(:twitter)
      user.auth(:twitter)
    else
      user.authentications.first
    end
  end

  # REFACTOR: DRY it up with more passed in options
  def link_to_authorize_social(provider, options={})
    from = options[:from]
    friendly_provider = provider.to_s.split("_").first
    case from
    when :account
      if current_user.has_auth?(provider)
        link_to friendly_provider, "javascript:void(0)", class: "dev #{friendly_provider}-added"
      else
        link_to friendly_provider, user_omniauth_authorize_path(provider), class: friendly_provider
      end
    when :signup
      if current_user.has_auth?(provider)
        link_to "javascript:void(0)", class: "btn btn-large #{friendly_provider}" do
          content_tag(:i, "", class: "icon-#{friendly_provider}-sign icon-large") + " #{friendly_provider} Added"
        end
      else
        link_to user_omniauth_authorize_path(provider), class: "btn btn-large #{friendly_provider}" do
          content_tag(:i, "", class: "icon-#{friendly_provider}-sign icon-large") + " Connect #{friendly_provider}"
        end
      end
    when :signin
      link_to user_omniauth_authorize_path(provider), class: "#{friendly_provider}" do
        content_tag(:i, "", class: "icon-#{friendly_provider}-sign icon-3x")
      end
    end
  end

  def link_to_follow_unfollow(user, options={})
    if current_user.following?(user)
      link_to "/relationships/#{current_user.relationships.find_by_followed_id(user).id}?style=#{options[:style]}", remote: true, method: :delete, class: "follow #{options[:style]}" do
        content_tag(:i, "", class: "icon-plus") + " Unfollow"
      end
    else
      link_to relationships_path(followed_id: user.id, style: options[:style]), remote: true, method: :post, class: "follow #{options[:style]}" do
        content_tag(:i, "", class: "icon-plus") + " Follow"
      end
    end
  end
end
