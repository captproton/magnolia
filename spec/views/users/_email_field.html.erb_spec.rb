require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

VIEW_PATH = "/users/_email_field.html.erb"

describe VIEW_PATH do
  include UsersHelper
  
  before(:each) do
    @user = assigns[:user] = stub_model(User,
      :new_record? => true,
      :screen_name => "value for screen_name",
      :password => "value for password",
      :email => 'value for email'
    )
    template.should_receive(:form_authenticity_token).and_return('token')
  end

  it "should render screen_name input" do
    render VIEW_PATH  
    response.should have_tag("input[name=?][type=text]", "user[email]")
  end
  
  it "should populate field with value from user" do    
    render VIEW_PATH  
    response.should have_tag("input[name='user[email]'][type=text][value=?]", 'value for email')
  end
end


