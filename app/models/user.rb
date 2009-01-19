# == Schema Information
# Schema version: 20090107200544
#
# Table name: users
#
#  id                    :integer(4)      not null, primary key
#  screen_name           :string(50)
#  first_name            :string(50)
#  email                 :string(255)
#  crypted_password      :string(255)
#  password_salt         :string(255)
#  remember_token        :string(255)
#  login_count           :integer(4)
#  last_request_at       :datetime
#  last_login_at         :datetime
#  current_login_at      :datetime
#  joined_at             :datetime
#  last_login_ip         :string(50)
#  current_login_ip      :string(50)
#  first_login_ip        :string(50)
#  active                :boolean(1)
#  accepted_terms_of_use :boolean(1)
#  activation_code       :string(40)
#  perishable_token      :string(255)     default(""), not null
#

# see also UserObserver
class User < ActiveRecord::Base
  
  acts_as_authentic :perishable_token_valid_for => 15.minutes, 
      :validate_fields => false, # authlogic's default validations don't play nice with OpenId
      :session_ids => [],
      :disable_perishable_token_maintenance => true
      
  validate :validate_email, :validate_screen_name, :validate_password, :validate_terms_of_use
    
  attr_accessor :openid_identifier
  attr_accessor :password_confirmation
  
  has_many :open_ids, :dependent => :destroy
  has_one :facebook_identity, :dependent => :destroy
  
  def to_param
  	screen_name
  end
  
  def self.find_by_open_id(open_id)
    query = <<-QUERY
      SELECT users.* FROM users, open_ids
      WHERE open_ids.openid_identifier = ?
      AND open_ids.user_id = users.id
      LIMIT 1
    QUERY
    user = User.find_by_sql( [ query, OpenIdAuthentication.normalize_url( open_id ) ] )
    user.empty? ? nil : user[0]
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserNotifier.deliver_password_reset_instructions(self)
  end
  
  # ==================
  # = Accessor Sugar =
  # ==================
  
  def name
    self.first_name.nil? ? self.screen_name : self.first_name
  end
  
  # ===============
  # = Validations =
  # ===============
  
  def validate_email
    if email.to_s.empty?
      errors.add_to_base( "You didn't fill out the email address field. Please enter your email address and try again.")

    elsif !(email.to_s =~ /^([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})$/)
      errors.add_to_base( "The email address you entered isn't valid. Please make sure your email address is in the name@email.com format.")

    elsif self.class.find( :first, 
                           :conditions => ( new_record? ? 
                                              ["email = ?", 
                                              email] : 
                                              ["email = ? AND #{self.class.primary_key} <> ?", 
                                            email, 
                                            id ] ) )
      errors.add_to_base( "The email address you've entered is already in use. You can only have one account per email address.")
    end    
  end
  
  def validate_screen_name
    if screen_name.to_s.empty?
      errors.add_to_base( "You didn't choose a screen name. Please enter a screen name and try again.")

    elsif screen_name.to_s.length < 2 && screen_name.to_s.length > 30
      errors.add_to_base( "Your screen name must be between 2 and 30 characters long. Please enter a new screen name and try again.")

    elsif !(screen_name.to_s =~ /^[A-Za-z0-9\-\.\_]+$/)
      errors.add_to_base( "Your screen name can only contain letters, numbers, dots, underscores, and dashes. Please make sure your screen name only contains these characters.")

    elsif self.class.find( :first, 
                            :conditions => 
                            ( new_record? ? 
                              ["screen_name = ?", screen_name] : 
                              ["screen_name = ? AND #{self.class.primary_key} <> ?", screen_name, id ] )
                            ) 
      errors.add_to_base( "The screen name you've chosen is already in use. Please pick another screen name and try again.")
    end  
  end
  
  def validate_password
    # TODO: Check if we should do any pw length or contents validation...
    if password.to_s.empty? && open_ids.empty? && self.facebook_identity.nil?
      errors.add_to_base( "You didn't choose a password. Please enter a password and try again.")      
    elsif open_ids.empty? && self.facebook_identity.nil? && (password.to_s != password_confirmation.to_s && !password_confirmation.nil?)
      errors.add_to_base( "Your password and confirmation did not match. Please re-enter them and try again.")      
    end    
  end
  
  def validate_terms_of_use    
    unless accepted_terms_of_use?
      errors.add_to_base( "Please check the box indicating that you agree to our terms of use.")
    end
  end
  
  
end
