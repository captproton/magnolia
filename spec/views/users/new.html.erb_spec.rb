require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

view_path = '/users/new.html.erb'

describe view_path do
  include UsersHelper
  
  before(:each) do
    @user = assigns[:user] = stub_model(User,
      :new_record? => true,
      :screen_name => "value for login",
      :password => "value for password"
    )
    template.stub!(:form_authenticity_token).and_return('token')
  end

  it "should render new form" do
    
    template.should_receive(:render).with( :partial => "/users/email_field" )
    template.should_receive(:render).with( :partial => "/users/screen_name_field" )
    template.should_receive(:render).with( :partial => "/users/terms_of_use" )
    
    render view_path
    
    response.should have_tag("form[action=?][method=post]", users_path) do
      with_tag("input#user_password[name=?]", "user[password]")
      with_tag("input#user_password_confirmation[name=?]", "user[password_confirmation]")
    end
  end
end


