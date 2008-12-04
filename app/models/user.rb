# == Schema Information
# Schema version: 20081110184646
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  screen_name            :string(50)
#  crypted_password       :string(255)
#  password_salt          :string(255)
#  remember_token         :string(255)
#  login_count            :integer(4)
#  last_request_at        :datetime
#  last_login_at          :datetime
#  current_login_at       :datetime
#  joined_at              :datetime
#  last_login_ip          :string(50)
#  current_login_ip       :string(50)
#  first_login_ip         :string(50)
#  activated              :boolean(1)
#  accepted_service_terms :boolean(1)
#  activation_code        :string(40)
#

class User < ActiveRecord::Base
  
  acts_as_authentic  
  
  attr_accessor :openid_identifier
  has_many :open_ids, :dependent => :destroy
  
  def to_param
  	screen_name
  end
  
end
