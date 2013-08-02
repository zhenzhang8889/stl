# == Schema Information
#
# Table name: goals
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  name       :string(255)
#

class Goal < ActiveRecord::Base
  attr_accessible :name
  belongs_to :user
end
