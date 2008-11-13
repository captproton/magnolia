require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/authentication/_auth_form.html.erb" do
  include AuthenticationProvidersHelper
  
  before(:each) do
    template.stub!(:select_label).and_return('Select Label')
    @aps = [stub_model(AuthenticationProvider), stub_model(AuthenticationProvider)]
    template.stub!(:auth_providers).and_return(@aps)
  end

  it "should render the provided select_label" do
    template.stub!(:render)
    render '/authentication/_auth_form.html.erb'
    response.should have_tag("p>label[ for='preferred_auth_provider[name]' ]", {:text => 'Select Label'})
  end
  
  it "should render auth_provider partial with auth_providers collection" do
    template.should_receive(:render).with( 
        :partial => 'authentication/auth_provider', 
        :collection => @aps 
        )
    render '/authentication/_auth_form.html.erb'
  end
  
  it "should render a javascript tag initializing an IdValueToggler for the select box" do
    template.stub!(:render)
    render '/authentication/_auth_form.html.erb'
    response.should have_tag( 'script', { :text => /IdValueToggler/, :count => 1 })
  end
  
  it "should render a check box for preferred auth method" do   
    template.stub!(:render)
    render '/authentication/_auth_form.html.erb'
    response.should have_tag( 'input#remember_selection[type="checkbox"]', {:count => 1} )
  end
  
end


