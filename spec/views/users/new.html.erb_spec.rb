require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/new.html.erb" do
  include UsersHelper
  
  before(:each) do
    assigns[:user] = stub_model(User,
      :new_record? => true,
      :screen_name => "value for login",
      :password => "value for password"
    )
  end

  it "should render new form" do
    
    template.should_receive(:render).with( :partial => "/users/email_field", :locals => {:f => anything()} )
    template.should_receive(:render).with( :partial => "/users/screen_name_field", :locals => {:f => anything()} )
    
    render "/users/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", users_path) do
      with_tag("input#user_password[name=?]", "user[password]")
      with_tag("input#user_password_confirmation[name=?]", "user[password_confirmation]")
    end
  end
end


