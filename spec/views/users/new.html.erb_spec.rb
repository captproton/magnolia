require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/new.html.erb" do
  include UsersHelper
  
  before(:each) do
    assigns[:user] = stub_model(User,
      :new_record? => true,
      :login => "value for login",
      :crypted_password => "value for crypted_password",
      :password_salt => "value for password_salt",
      :remember_token => "value for remember_token",
      :login_count => "1",
      :last_login_ip => "value for last_login_ip",
      :current_login_ip => "value for current_login_ip"
    )
  end

  it "should render new form" do
    render "/users/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", users_path) do
      with_tag("input#user_login[name=?]", "user[login]")
      with_tag("input#user_crypted_password[name=?]", "user[crypted_password]")
      with_tag("input#user_password_salt[name=?]", "user[password_salt]")
      with_tag("input#user_remember_token[name=?]", "user[remember_token]")
      with_tag("input#user_login_count[name=?]", "user[login_count]")
      with_tag("input#user_last_login_ip[name=?]", "user[last_login_ip]")
      with_tag("input#user_current_login_ip[name=?]", "user[current_login_ip]")
    end
  end
end


