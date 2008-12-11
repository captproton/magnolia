# == Schema Information
# Schema version: 20081119192750
#
# Table name: open_ids
#
#  id                :integer(4)      not null, primary key
#  openid_identifier :string(255)
#  user_id           :integer(4)
#

class OpenId < ActiveRecord::Base

  belongs_to :user
  
  before_save :normalize_openid_identifier!
  
  private
  
    def normalize_openid_identifier!
      @attributes['openid_identifier'] = OpenIdAuthentication.normalize_url(self.openid_identifier)
    end
  
end
