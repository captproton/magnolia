class OpenId < ActiveRecord::Base

  belongs_to :user
  
  before_save :normalize_openid_identifier!
  
  private
  
    def normalize_openid_identifier!
      @attributes['openid_identifier'] = OpenIdAuthentication.normalize_url(self.openid_identifier)
    end
  
end
