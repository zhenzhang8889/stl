module Stackable
  extend ActiveSupport::Concern

  def already_stacked_on?(s)
    StackedItem.where(stack_id: s.id, 
      stackable_id: self.id, 
      stackable_type: self.type_name
    ).present?
  end
end
