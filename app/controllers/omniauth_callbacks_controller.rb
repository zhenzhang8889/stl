class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    omni = request.env["omniauth.auth"]
    auth = Authentication.find_for(omni)

    case
    when auth_but_no_current(auth)
      # just sign in and update details
      auth.update_details(omni)
      flash.notice = "Signed in!"
      sign_in_and_redirect( auth.user )

    when no_auth_but_current(auth)
      # just add the auth to current user
      current_user.attach_social( omni )
      redirect_to social_success_path
      flash.notice = "Facebook Added"

    when no_auth_and_no_current(auth)
      # create new twitter auth and redirect to new user form for email
      session[:omniauth] = omni.except('extra')
      user = User.from_omniauth(omni)
      user.authentications.create(:provider => omni[:provider],
        :uid => omni[:uid],
        :token => omni[:credentials][:token],
        :token_secret => omni[:credentials][:secret],
        :image => omni[:info][:image])

      flash.notice = "Signed in!"
      sign_in(user)
      session[:fresh_facebook] = true
      redirect_to "/after_signup/connect"
    else
      redirect_to social_success_path
      flash.notice = "This social profile is already connected to another account"
    end
  end

  def all_else
    omni = request.env["omniauth.auth"]
    auth = Authentication.find_for(omni)

    case
    when auth_but_no_current(auth)
      # update and sign in
      auth.update_details(omni)
      flash.notice = "Signed in!"
      sign_in_and_redirect( auth.user )

    when no_auth_but_current(auth)
      # just add the auth to current user
      current_user.attach_social( omni )
      redirect_to social_success_path
      flash.notice = "#{omni[:provider].to_s.capitalize} Added"

    when no_auth_and_no_current(auth)

      session[:omniauth] = omni.except('extra')
      user = User.from_omniauth(omni)

      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    else
      redirect_to settings_users_path(current_user, omniauth: true)
      flash.notice = "This social profile is already connected to another account"
    end
  end

  alias_method :twitter, :all_else
  alias_method :linkedin, :all_else
  alias_method :google_oauth2, :all_else

  private
    def auth_but_no_current(auth)
      auth.present? && !current_user
    end

    def no_auth_but_current(auth)
      !auth.present? && current_user
    end

    def no_auth_and_no_current(auth)
      !auth.present? && !current_user
    end

    def social_success_path
      if request.referer.include?("after_signup")
        "/after_signup/connect"
      else
        settings_users_path(current_user, omniauth: true)
      end
    end
end


