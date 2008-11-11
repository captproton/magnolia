require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helpers/authentication_provider_spec_helper')
include AuthenticationProviderSpecHelper

describe AuthenticationProvider do

  it "should create a new instance given valid attributes" do
    AuthenticationProvider.create!(valid_provider_attributes)
  end
  
  it "should require a value for name" do
    ap = AuthenticationProvider.create( valid_provider_attributes.except(:name) )
    ap.should have(1).error_on(:name)
  end
  
  it "should provide access to the logo path for AP with logo value" do
    ap = AuthenticationProvider.create!(valid_provider_attributes)
    ap.logo.should match(Regexp.new(ap.logo))
  end
  
  it "should return nil for logo_path for AP without logo value" do
    ap = AuthenticationProvider.create!(valid_provider_attributes.except(:logo))
    ap.logo.should be_nil
  end
  
end
