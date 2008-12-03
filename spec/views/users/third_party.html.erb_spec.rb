require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

VIEW_PATH = "/users/third_party.html.erb"

describe VIEW_PATH do
  include UsersHelper

  it "should render new form" do
    render VIEW_PATH
    
    response.should have_tag("form[action=?][method=post]", users_path() ) do
      with_tag("input#openid_identifier[name=?]", "openid_identifier")
    end
    response.should have_tag('a[href=?]', new_user_path)
  end
end


