require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helpers/authentication_provider_spec_helper')
include AuthenticationProviderSpecHelper

describe "/admin/authentication_providers/show.html.erb" do
  include AuthenticationProvidersHelper
  
  before(:each) do
    assigns[:authentication_provider] = @authentication_provider = stub_model(AuthenticationProvider, valid_provider_attributes )
  end
  
  it "should render attributes in <p>" do
    render "/admin/authentication_providers/show.html.erb"
    response.should have_text(/value for name/)
    response.should have_text(/value for label/)
    response.should have_text(/logo.png/)
    response.should have_text(/button.png/)
    response.should have_text(/value for description/)
    response.should have_text(/false/)
    response.should have_text(/OpenIdProvider/)
    response.should have_text(/1/)
  end
end

