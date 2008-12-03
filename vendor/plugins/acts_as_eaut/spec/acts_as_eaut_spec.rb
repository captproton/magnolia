require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../lib/acts/eaut'

require 'openid'
require 'ruby-debug'
require 'net/http'

class Controller
  include Acts::Eaut
  acts_as_eaut
end

describe Acts::Eaut do 
  
  before(:each) do
    @controller = Controller.new
    @mapping_endpoint = OpenID::Yadis::BasicServiceEndpoint.new(
        'http://jesseclark.com', ['http://specs.eaut.org/1.0/mapping'], 'http://emailtoid.net/', '')   
    @invalid_endpoint = OpenID::Yadis::BasicServiceEndpoint.new(
        'http://jesseclark.com', ['http://foo.com'], 'http://jesseclark.com', '') 
    @template_endpoint = OpenID::Yadis::BasicServiceEndpoint.new(
        'http://jesseclark.com', ['http://specs.eaut.org/1.0/template'], 'http://jesseclark.myopenid.com', '')    
    @replace_endpoint = OpenID::Yadis::BasicServiceEndpoint.new(
        'http://jesseclark.com', ['http://specs.eaut.org/1.0/template'], 'http://%7Busername%7D.myopenid.com', '')    
    @endpoints = [
      @invalid_endpoint
    ]
  end
  
  it 'build_mapper_url should return a valid url with an email appended' do
    mapper_url = @controller.build_mapper_url(@mapping_endpoint, 'jesse@jesseclark.com', '?')
    uri = URI.parse(mapper_url)
    uri.to_s.should match( /\?email=jesse@jesseclark.com/ )
  end
  
  it 'get_eaut_endpoint should raise error when no eaut endpoints are present' do
    OpenID::Yadis.expects(:get_service_endpoints).returns(@endpoints)
    lambda{ @controller.get_eaut_endpoint('http://jesseclark.com') }.should raise_error(Acts::Eaut::NoValidEndpoints)
  end
  
  it 'get_eaut_endpoint should return eaut endpoints when present' do
    @endpoints << @template_endpoint
    OpenID::Yadis.expects(:get_service_endpoints).returns(@endpoints)
    endpoint = Controller.new.get_eaut_endpoint('http://jesseclark.com')
    endpoint.uri.should ==( 'http://jesseclark.myopenid.com' )
  end
  
  it 'return open_id should raise an error for an email domain that has no eaut endpoint and no fallback' do
    OpenID::Yadis.stubs(:get_service_endpoints).returns(@endpoints)
    lambda { @controller.get_openid_for_email( 'jesse@jesseclark.com' ) }.should raise_error(Acts::Eaut::NoValidEndpoints)
  end
  
  it 'return open_id should return an open_id for an email domain that has a template service' do
    Controller.any_instance.stubs(:get_eaut_endpoint).with('http://jesseclark.com').returns(@template_endpoint)
    @controller.get_openid_for_email( 'jesse@jesseclark.com' ).should == 'http://jesseclark.myopenid.com'
  end
  
  it 'return open_id should return a transformed open_id for an email domain that has a template service with a replace string' do
    Controller.any_instance.stubs(:get_eaut_endpoint).with('http://jesseclark.com').returns(@replace_endpoint)
    @controller.get_openid_for_email( 'jesse@jesseclark.com' ).should == 'http://jesse.myopenid.com'
  end
  
  it 'return open_id should get endpoints from the fallback url if a domain has no valid eaut endpoints' do
    Controller.any_instance.expects(:get_eaut_endpoint).with('http://jesseclark.com').raises(Acts::Eaut::NoValidEndpoints)
    Controller.any_instance.expects(:get_eaut_endpoint).with(Acts::Eaut::FALLBACK_SERVICE).returns(@mapping_endpoint)
    response = mock('response')
    response.expects(:code).returns('302')
    response.expects(:[]).with('location').returns('http://jesseclark.myopenid.com')
    Net::HTTP.stubs(:start).returns(response)
    @controller.get_openid_for_email( 'jesse@jesseclark.com' )
  end
    
  it 'return open_id should return an open_id for an email domain that has a mapping service that knows the user' do
    Controller.any_instance.stubs(:get_eaut_endpoint).with('http://jesseclark.com').returns(@mapping_endpoint)
    response = mock('response')
    response.expects(:code).returns('302')
    response.expects(:[]).with('location').returns('http://jesseclark.myopenid.com')
    Net::HTTP.stubs(:start).returns(response)
    @controller.get_openid_for_email( 'jesse@jesseclark.com' ).should == 'http://jesseclark.myopenid.com'
  end
  
  it 'return open_id should raise an error for an email domain that has a mapping service that does not redirect' do
    Controller.any_instance.stubs(:get_eaut_endpoint).with('http://jesseclark.com').returns(@mapping_endpoint)
    response = mock('response')
    response.expects(:code).returns(['404'])    
    Net::HTTP.stubs(:start).returns(response)
    lambda { @controller.get_openid_for_email( 'jesse@jesseclark.com' ) }.should raise_error( Acts::Eaut::OpenIDTranslationError )
  end
  
end
