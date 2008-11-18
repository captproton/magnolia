require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/user_sessions/new.html.erb" do
  include UserSessionsHelper
  
  before(:each) do
    assigns[:user_session] = stub_model(User, :new_record? => true )
    assigns[:auth_providers] = []
  end
  
  it "should render auth_form partial" do
    template.should_receive(:render).with( 
        :partial => 'authentication/auth_form', 
        :locals => { :select_label => 'Sign in using', :auth_providers => assigns[:auth_providers] } 
        )
    render "/user_sessions/new.html.erb"
  end
  
end


