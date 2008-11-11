require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helpers/authentication_provider_spec_helper')
include AuthenticationProviderSpecHelper

describe "/admin/authentication_providers/index.html.erb" do
  include AuthenticationProvidersHelper
  
  before(:each) do
    assigns[:authentication_providers] = [
      stub_model(AuthenticationProvider, valid_provider_attributes ),
      stub_model(AuthenticationProvider, valid_provider_attributes )
    ]
  end

  it "should render list of admin_authentication_providers" do
    render "/admin/authentication_providers/index.html.erb"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "value for label", 2)
    response.should have_tag("tr>td", "logo.png", 2)
    response.should have_tag("tr>td", "button.png", 2)
    response.should have_tag("tr>td", "value for description", 2)
    response.should have_tag("tr>td", 'false', 2)
    response.should have_tag("tr>td", 'OpenIdProvider', 2)
    response.should have_tag("tr>td", "1", 2)
  end
end

