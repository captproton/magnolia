require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

view_path = '/password_resets/new.html.erb'

describe view_path do
  
  include UsersHelper

  it "should render form for password reset" do
    render view_path
    response.should have_tag("form[action=?][method=post]", password_resets_path ) do
      with_tag("input#identifier[type=text]")
      with_tag("input[type=submit]")
    end
  end
  
end


