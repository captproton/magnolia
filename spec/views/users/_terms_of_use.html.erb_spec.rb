require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/_terms_of_use.html.erb" do
  include UsersHelper
  
  before(:each) do
    assigns[:user] = stub_model(User,
      :new_record? => true,
      :screen_name => "value for login",
      :password => "value for password",
      :accepted_terms_of_use => true
    )
  end

  it "should render tos checkbox" do
    render "/users/_terms_of_use.html.erb"
    response.should have_tag("input[name=?][type=checkbox]", "user[accepted_terms_of_use]")
  end
end


