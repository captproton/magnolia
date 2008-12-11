require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

VIEW_PATH = "/users/_screen_name_field.html.erb"

describe VIEW_PATH do
  include UsersHelper
  
  before(:each) do
    @user = assigns[:user] = stub_model(User,
      :new_record? => true,
      :screen_name => "value for screen_name",
      :password => "value for password"
    )
    template.should_receive(:form_authenticity_token).and_return('token')
  end

  it "should render screen_name input" do
    render VIEW_PATH  
    response.should have_tag("input[name=?][type=text]", "user[screen_name]")
  end
  
  it "should populate field with value from user" do    
    render VIEW_PATH  
    response.should have_tag("input[name='user[screen_name]'][type=text][value=?]", 'value for screen_name')
  end
end


