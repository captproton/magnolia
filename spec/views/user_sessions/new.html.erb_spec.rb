require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/user_sessions/new.html.erb" do
  include UserSessionsHelper
  
  before(:each) do
    Authlogic::Session::Base.controller = UserSessionsController.new
    assigns[:user_session] = UserSession.new
  end
  
  it "should render form" do
    render "/user_sessions/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", user_session_path) do
      with_tag("input#openid_identifier[name=?]", "openid_identifier")
      with_tag('input#user_session_remember_me[type=checkbox][name=?]', 'user_session[remember_me]' )
    end
  end
  
  it "should render password form when flag is set" do
    assigns[:show_password_form] = @show_password_form = true
    template.should_receive(:render).with( :partial => "password_form" )
    render "/user_sessions/new.html.erb"
  end
  
end


