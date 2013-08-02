# == Schema Information
#
# Table name: groups
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  user_id     :integer
#

class Group < ActiveRecord::Base

	has_and_belongs_to_many :user

  attr_accessible :description, :name
end
