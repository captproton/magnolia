require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

view_path = '/user_activations/update.html.erb'

describe view_path do
  include UsersHelper
  
  before(:each) do
    @current_user = assigns[:current_user] = stub_model(User,
      :new_record? => true,
      :screen_name => "value for login",
      :password => "value for password"
    )
  end

  it "should render form 'Done for Now'" do
    render view_path
    response.should have_tag("form[action=?][method=get]", user_path(@current_user) ) do
      with_tag("input[type=submit][value=?]", 'Done for Now')
    end
  end
  
  it "should render form 'Begin Orientation'" do
    render view_path
    response.should have_tag("form[action=?][method=get]", orientation_url ) do
      with_tag("input[type=submit][value=?]", 'Begin Orientation')
    end
  end
  
end


