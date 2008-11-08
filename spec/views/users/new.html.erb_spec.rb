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
    render "/users/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", users_path) do
      with_tag("input#user_screen_name[name=?]", "user[screen_name]")
      with_tag("input#user_password[name=?]", "user[password]")
      with_tag("input#user_confirm_password[name=?]", "user[confirm_password]")
    end
  end
end


