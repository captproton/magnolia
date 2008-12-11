require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

view_path = '/user_activations/new.html.erb'

include UsersHelper

describe view_path do
  
  before(:each) do
    @current_user = assigns[:current_user] = stub_model(User, :email => 'foo@bar.com' )
  end

  it "should render user's email address" do
    template.should_receive(:render).with( :partial => 'user_activations/resend_submits' )
    render view_path
    response.should have_text( Regexp.new(@current_user.email) )
  end
  
end


