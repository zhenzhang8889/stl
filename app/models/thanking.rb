# == Schema Information
#
# Table name: thankings
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  thanker_id     :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  resource_class :string(255)
#  resource_id    :integer
#

class Thanking < ActiveRecord::Base
  attr_accessible :thanker_id, :resource_class, :resource_id

  belongs_to :user, :counter_cache => true
  belongs_to :thanker, :class_name => User

  validates_presence_of :user_id, :resource_class, 
  						:resource_id, :thanker_id
  validates_uniqueness_of :thanker_id, :scope => [:resource_id, :resource_class, :user_id]

  def resource_object
  	model = resource_class.to_s.downcase.capitalize.constantize
  	model.find( resource_id )
  end

  def resource_description
  	case resource_class
  		when 'workout'
  			resource_object.name
  		when 'post'
  			resource_object.name
      when 'status'
        resource_object.content
  	end
  end
end


