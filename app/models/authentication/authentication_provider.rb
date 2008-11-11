# == Schema Information
# Schema version: 20081110184646
#
# Table name: authentication_providers
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)     default(""), not null
#  type             :string(255)     default("AuthenticationProvider"), not null
#  label            :string(255)
#  logo             :string(255)
#  button           :string(255)
#  description      :text
#  active           :boolean(1)      default(TRUE), not null
#  display_sequence :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#

# This class and its subclasses are used to encapsulate the data for displaying the authentication forms
# for the various types of authentication providers we support.
#
# - <tt>PasswordProvider</tt>:: Our basic Ma.gnolia un/pw form.
# - <tt>OpenIdProvider</tt>:: The generic OpenId form.
# - <tt>KnownProvider</tt>:: Presents an OpenId form customized for a given OpenId provider ( e.g. hosted blogs that provide open_id )
# - <tt>OneClickProvider</tt>:: Presents a form with a button_to link and without a text input. ( e.g. Facebook, Yahoo directed identity )
# - <tt>ClickpassProvider</tt>:: Clickpass integration didn't fit the abstraction of OpenId nor KnownProvider so it gets handled as a unique case.
# - <tt>WindowsLiveIdProvider</tt>:: LiveId authentication required a unique case as well.
#
class AuthenticationProvider < ActiveRecord::Base
  
  named_scope :active, :conditions => { :active => true }
  
  validates_presence_of :name
  
  # Provides access to the path to the logo for this AuthenticationProvider
  def logo_path
    unless logo.blank?
      "auth/logos/#{logo}"
    else
      nil
    end
  end

  # Provides access to the path to one click button for this AuthenticationProvider  
  # -- TODO: this only needs to be defined for OneClick providers. Move to subclass.
  def button_path
    unless button.blank?
      "auth/buttons/#{button}"
    else
      ''
    end
  end
  
end
