require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

view_path = '/user_activations/_resend_submits.html.erb'

describe view_path do
  include UsersHelper
  
  before(:each) do
    @current_user = assigns[:current_user] = stub_model(User,
      :new_record? => true,
      :screen_name => "value for login",
      :password => "value for password"
    )
  end

  it "should render form 'Resend Email'" do
    render view_path
    response.should have_tag("form[action=?][method=get]", new_user_activation_path ) do
      with_tag("input[type=submit][value=?]", 'Resend Email')
    end
  end
  
  it "should render form 'Start Over'" do
    render view_path
    response.should have_tag("form[action=?][method=get]", signup_path ) do
      with_tag("input[type=submit][value=?]", 'Start Over')
    end
  end
  
end


