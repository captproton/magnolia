require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include AuthenticationSpecHelper

describe User do
  before(:each) do
    @valid_attributes = {
      :email => 'value@email.com',
      :screen_name => "screen_name",
      :password => 'value for password',
      :password_confirmation => 'value for password',
      :crypted_password => "value for crypted_password",
      :password_salt => "value for password_salt",
      :remember_token => "value for remember_token",
      :login_count => "1",
      :last_request_at => Time.now,
      :last_login_at => Time.now,
      :current_login_at => Time.now,
      :last_login_ip => "value for last_login_ip",
      :current_login_ip => "value for current_login_ip"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end

  it "should fail validation with missing email" do
    user = User.create( @valid_attributes.except(:email) )
    user.should have(1).error_on(:base)
    user.errors.on_base.should match(/Please enter your email address/)
  end
  
  it "should fail validation with invalid email" do
    user = User.create( @valid_attributes.update( :email => 'big fail' ) )
    user.should have(1).error_on(:base)
    user.errors.on_base.should match(/email address you entered isn't valid/)
  end
  
  it "should fail validation with already in use email" do
    # I have no idea why the validation methods are being executed twice here...
    User.should_receive( :find ).with( :first, :conditions => ["email = ?", "value@email.com"] ).twice().and_return( mock_user )
    User.should_receive( :find ).with( :first, :conditions => ["screen_name = ?", "screen_name"] ).twice().and_return( nil )
    user = User.create( @valid_attributes )
    user.should have(1).error_on(:base)
    user.errors.on_base.should match(/email address you've entered is already in use/)
  end
  
  it "should fail validation with missing screen_name" do
    user = User.create( @valid_attributes.except(:screen_name) )
    user.should have(1).error_on(:base)
    user.errors.on_base.should match(/Please enter a screen name/)
  end
  
  it "should fail validation with invalid screen_name" do
    user = User.create( @valid_attributes.update( :screen_name => 'big fail' ) )
    user.should have(1).error_on(:base)
    user.errors.on_base.should match(/Your screen name can only contain/)
  end
  
  it "should fail validation with already in use screen_name" do
    # I have no idea why the validation methods are being executed twice here...
    User.should_receive( :find ).with( :first, :conditions => ["email = ?", "value@email.com"] ).twice().and_return( nil )
    User.should_receive( :find ).with( :first, :conditions => ["screen_name = ?", "screen_name"] ).twice().and_return( mock_user )
    user = User.create( @valid_attributes )
    user.should have(1).error_on(:base)
    user.errors.on_base.should match(/screen name you've chosen is already in use/)
  end
  
  it "should fail validation with missing password without another form of identity" do
    user = User.create( @valid_attributes.except(:password) )
    user.should have(1).error_on(:base)
    user.errors.on_base.should match(/Please enter a password/)
  end
  
  it "should NOT fail validation with missing password with another form of identity" do
    open_id = mock_model(OpenId, :valid? => true, :save => true )
    open_id.stub!( :[]= )
    user = User.create( @valid_attributes.merge( :open_ids => [ open_id ] ).except(:password) )
    user.should have(:no).errors_on(:base)
  end
  
  it "should fail validation when password and confirmation don't match" do
    user = User.create( @valid_attributes.update( :password => 'big fail' ) )
    user.should have(1).error_on(:base)
    user.errors.on_base.should match(/password and confirmation did not/)
  end
  
  
end
