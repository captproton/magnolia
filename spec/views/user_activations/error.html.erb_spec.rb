require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

view_path = '/user_activations/error.html.erb'

describe view_path do
  include UsersHelper
  
  before(:each) do
  end

  it "should render form the resend submits partial" do
    template.should_receive(:render).with( :partial => 'resend_submits' )
    render view_path
  end

  
end


