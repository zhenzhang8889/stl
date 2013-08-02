module Taggable
  extend ActiveSupport::Concern

  included do
    acts_as_taggable
    acts_as_taggable_on :shares
  end
end