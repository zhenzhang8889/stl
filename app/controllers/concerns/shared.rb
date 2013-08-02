module Shared
  extend ActiveSupport::Concern

  def share_modal
    klass = params[:c_type].constantize
    @content = klass.find(params[:c_id])
    respond_to do |format|
      format.js { render "shared/share_modal" }
    end
  end

  def share
    klass = params[:controller].singularize.capitalize.constantize
    @content = klass.find(params[:id])
    respond_to do |format|
      begin
        if !params[:"#{@content.low_type_name}"][:share_list].blank?
          @content.update_attribute(:share_list, params[:"#{@content.low_type_name}"][:share_list])
          format.js { render "shared/share_submit", locals: { status: :success } }
        else
          format.js { render "shared/share_submit", locals: { status: :blank } }
        end
      rescue
        format.js { render "shared/share_submit", locals: { status: :error } }
      end
    end
  end
end