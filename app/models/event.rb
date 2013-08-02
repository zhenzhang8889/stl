# == Schema Information
#
# Table name: events
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  location    :string(255)
#  price       :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  user_id     :integer
#

class Event < ActiveRecord::Base
  belongs_to :user

  attr_accessible :description, :location, :name, :price
end
