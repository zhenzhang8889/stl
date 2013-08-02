class RegistrationsController < Devise::RegistrationsController
	def create
		super
		if resource.save && session[:omniauth]
			omni = session[:omniauth]

			resource.authentications.create(:provider => omni[:provider],
				:uid => omni[:uid],
				:token => omni[:credentials][:token],
				:token_secret => omni[:credentials][:secret],
				:image => omni[:info][:image])

			session[:omniauth] = nil unless @user.new_record?
		end
	end

	def update
    # required for settings form to submit when password is left blank
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      respond_to do |format|
        format.html { redirect_to after_update_path_for(@user) }
        format.js { render :js => "window.location.replace('#{after_update_path_for(@user)}');" }
      end
    else
      respond_to do |format|
        format.html { (params[:user_settings]) ? (render :edit) : (render "users/settings") }
        format.js { render 'errors' }
      end
    end
  end
end