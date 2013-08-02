module Stacked
  extend ActiveSupport::Concern

  def save_to_stacks
    klass = params[:controller].singularize.capitalize.constantize
    @content = klass.find(params[:id])
    respond_to do |format|
      if !params[:stacks]
        format.js { render partial: "stacks/save_modal_error", locals: { blank: true } }
      else
        @stacks = Stack.find(params[:stacks])
        @already = Array.new
        saved = Array.new
        @stacks.each do |s|
          if @content.already_stacked_on?(s)
            @already.push(s.name)
          else
            saved.push(saved.count + 1)
            s.add_stacked_item_for(@content)
          end
        end
        case @already.count
        when Proc.new { |n| n > 0 }
          format.js { render partial: "stacks/save_modal_error", locals: { blank: false } }
        else
          format.js { render partial: "stacks/save_modal_success" }
        end
      end
    end
  end
end
