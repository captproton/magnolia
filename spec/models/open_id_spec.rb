require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe OpenId do
  before(:each) do
    @valid_attributes = {
      :openid_identifier => 'http://foo.myopenid.com'
    }
  end

  it "should create a new instance given valid attributes" do
    OpenId.create!(@valid_attributes)
  end
end
