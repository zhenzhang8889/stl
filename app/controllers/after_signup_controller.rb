class AfterSignupController < ApplicationController
  include Wicked::Wizard

  steps :connect, :interests, :follow

  def show
    case step
    when :follow
      # @top_users = User.all.sort_by(&:followers_count).reverse.take(30)
      @network = User.order("followers_count DESC").paginate(page: params[:page]).per_page(50)
    when :connect
      if session[:fresh_facebook]
        session[:fresh_facebook] = nil
        redirect_to next_wizard_path and return
      end
    end
    @user = current_user
    render_wizard
  end
end
