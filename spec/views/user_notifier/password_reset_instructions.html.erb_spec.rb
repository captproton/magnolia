require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include UsersHelper

view_path = '/user_notifier/password_reset_instructions.html.erb'
  
describe view_path do
  
  before(:each) do
    @user = assigns[:user] = stub_model(User, :perishable_token => 'p_token', :name => 'Foo' )
    template.stub!(:form_authenticity_token).and_return('token')
  end

  it "should render the activation url" do
    render view_path
    response.should have_text( Regexp.new( edit_password_reset_url( @user.perishable_token ) ) )
  end
  
  it "should render the user's name" do
    render view_path
    response.should have_text( Regexp.new( @user.name ) )
  end
  
end