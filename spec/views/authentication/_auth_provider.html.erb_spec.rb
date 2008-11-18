require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

VIEW_PATH = '/authentication/_auth_provider.html.erb'

describe VIEW_PATH do
  include AuthenticationProvidersHelper
  
  before(:each) do    
    @ap = stub_model(OpenIdProvider, {:name => 'authentication_provider'})
    template.stub!(:auth_provider).and_return( @ap )
  end
  
  it "should render a form for the provider" do
    template.stub!(:render)
    render VIEW_PATH
    response.should have_tag("form[action=?][method=post][id=?]", user_session_path, "#{@ap.type.underscore}_form")
  end
  
  it "should render the partial associated with the provider class" do  
    template.should_receive(:render).with( 
       :partial => "authentication/#{@ap.type.underscore}",
       :object => @ap
       )
    render VIEW_PATH
  end
  
  it "should render a div with an id equal to the name of provider" do
    template.stub!(:render)   
    render '/authentication/_auth_provider.html.erb' 
    response.should have_tag("div##{@ap.name.downcase}")
  end 
  
end


