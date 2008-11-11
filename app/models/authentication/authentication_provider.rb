class AuthenticationProvider < ActiveRecord::Base
  
  named_scope :active, :conditions => { :active => true }
  
  validates_presence_of :name
  
  def logo_path
    unless logo.blank?
      "auth/logos/#{logo}"
    else
      nil
    end
  end
  
  # TODO: this only needs to be defined for OneClick providers. Move to subclass.
  def button_path
    unless button.blank?
      "auth/buttons/#{button}"
    else
      ''
    end
  end
  
end
