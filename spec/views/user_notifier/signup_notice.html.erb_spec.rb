require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include UsersHelper

view_path = '/user_notifier/signup_notice.html.erb'
  
describe view_path do
  
  before(:each) do
    @user = assigns[:user] = stub_model(User, :perishable_token => 'p_token' )
    template.stub!(:form_authenticity_token).and_return('token')
  end

  it "should render the activation url" do
    render view_path
    response.should have_text( Regexp.new( user_activation_url( @user.perishable_token ) ) )
  end
  
end