require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helpers/authentication_provider_spec_helper')
include AuthenticationProviderSpecHelper

describe "/admin/authentication_providers/new.html.erb" do
  include AuthenticationProvidersHelper
  
  before(:each) do
    assigns[:authentication_provider] = stub_model(AuthenticationProvider, valid_provider_attributes )
    assigns[:authentication_provider_types] = @authentication_provider_types = ['OpenIdProvider']
  end

  it "should render new form" do
    render "/admin/authentication_providers/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", admin_authentication_providers_path) do
      with_tag("input#authentication_provider_name[name=?]", "authentication_provider[name]")
      with_tag("select#authentication_provider_type[name=?]", "authentication_provider[type]")
      with_tag("input#authentication_provider_label[name=?]", "authentication_provider[label]")
      with_tag("input#authentication_provider_logo[name=?]", "authentication_provider[logo]")
      with_tag("input#authentication_provider_button[name=?]", "authentication_provider[button]")
      with_tag("input#authentication_provider_description[name=?]", "authentication_provider[description]")
      with_tag("input#authentication_provider_active[name=?]", "authentication_provider[active]")
      with_tag("input#authentication_provider_display_sequence[name=?]", "authentication_provider[display_sequence]")
    end
  end
end


