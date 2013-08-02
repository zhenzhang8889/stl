class StackedItem < ActiveRecord::Base
  attr_accessible :stackable_id, :stackable_type

  belongs_to :stackable, polymorphic: true
  belongs_to :stack
end
