require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/authentication/_auth_provider.html.erb" do
  include AuthenticationProvidersHelper
    
  it "should render the partial associated with the provider class" do  
    ap = stub_model(ClickpassProvider, {:name => 'authentication_provider'})
    template.stub!(:auth_provider).and_return( ap )     
    template.should_receive(:render).with( 
       :partial => "authentication/#{ClickpassProvider.name.underscore}",
       :object => ap
       )
    render '/authentication/_auth_provider.html.erb'
  end
   
end


