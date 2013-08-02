module Nestable
  extend ActiveSupport::Concern

  included do
    accepts_nested_attributes_for :videos
    accepts_nested_attributes_for :images
  end
end