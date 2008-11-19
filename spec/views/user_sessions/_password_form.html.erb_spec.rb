require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

VIEW_PATH = "/user_sessions/_password_form.html.erb"

describe VIEW_PATH do
  include UserSessionsHelper
  
  before(:each) do
    Authlogic::Session::Base.controller = UserSessionsController.new
    assigns[:user_session] = UserSession.new
  end
  
  it "should render form" do
    render VIEW_PATH
    
    response.should have_tag("form[action=?][method=post]", user_session_path) do
      with_tag("input#user_session_email[name=?]", "user_session[email]")
      with_tag("input#user_session_password[type=password][name=?]", "user_session[password]")
      with_tag('input#user_session_remember_me[type=checkbox][name=?]', 'user_session[remember_me]' )
    end
  end

end


