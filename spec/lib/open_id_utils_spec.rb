require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class FakeController < ApplicationController
  include OpenIdUtils
end

describe FakeController, 'including OpenIdUtils', :type => :controller do

  before(:all) do
    ActionController::Routing::Routes.add_route('fake/create', :controller => 'fake', :action => 'create')
    @controller = FakeController
  end
  
  after(:all) do
    ActionController::Routing::Routes.reload
  end
  
  it "should return true from using_open_id? if openid_identifier param is present" do
    @controller.params = {}
    @controller.params[:openid_identifier] = 'foo'
    @controller.send( 'using_open_id?' ).should ==(true)
  end
  
  it "should return true from using_open_id? if openid_url param is present" do
    @controller.params = {}
    @controller.params[:openid_url] = 'foo'
    @controller.send( 'using_open_id?' ).should ==(true)
  end
  
end


