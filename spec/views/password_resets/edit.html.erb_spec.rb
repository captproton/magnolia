require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

view_path = '/password_resets/edit.html.erb'
include AuthenticationSpecHelper

describe view_path do
  
  include UsersHelper
  
  before(:each) do    
    @user = assigns[:user] = mock_user( 
        :password => "value for password", 
        :password_confirmation => 'value for password',
        :perishable_token => 'p_token' )
  end
  
  it "should render form for password reset" do
    render view_path
    response.should have_tag("form[action=?][method=post]", password_reset_path(@user.perishable_token) ) do
      with_tag("input[name=_method][value=put]")
      with_tag("input#user_password[type=password][name=?]", 'user[password]')
      with_tag("input#user_password_confirmation[type=password][name=?]", 'user[password_confirmation]')
      with_tag("input[type=submit]")
    end
  end
  
end


