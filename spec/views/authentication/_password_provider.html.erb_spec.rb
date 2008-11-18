require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe '/authentication/_password_provider.html.erb' do
  include AuthenticationProvidersHelper

  it "should render un/pw form fields" do
    render '/authentication/_password_provider.html.erb'
    response.should have_tag( "input#user_session_screen_name[name='user_session[screen_name]']" ) 
    response.should have_tag( "input#user_session_screen_name[type='text']" )
    response.should have_tag( "input#user_session_password[name='user_session[password]']" ) 
    response.should have_tag( "input#user_session_password[type='password']" )
  end
  
  it "should render the un field filled out if @screen_name is set" do    
    assigns[:screen_name] = 'screen_name value'
    render '/authentication/_password_provider.html.erb'
    response.should have_tag( "input#user_session_screen_name[name='user_session[screen_name]']", :value => 'screen_name value' )
  end  
  
end