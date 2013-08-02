# == Schema Information
#
# Table name: authentications
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  provider         :string(255)
#  uid              :string(255)
#  token            :string(255)
#  token_secret     :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  image            :string(255)
#  refresh_token    :string(255)
#  token_expires_at :string(255)
#

class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :token, :token_secret, :uid, 
  				  :image, :refresh_token, :token_expires_at

  def self.find_for( omni )
  	where(provider: omni[:provider], uid: omni[:uid]).first
  end

  def update_details(omni)
  	self.update_attributes(:token => omni[:credentials][:token],
      :token_secret => omni[:credentials][:secret],
      :refresh_token => omni[:credentials][:refresh_token],
      :token_expires_at => omni[:credentials][:token_expires_at],
      :image => omni[:info][:image])
  end
end
