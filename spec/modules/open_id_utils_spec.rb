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
  
  describe "responding to POST create" do
      
    describe "when openid_identifier is set" do
      
      it "should call open_id_authentication" do
        @controller.should_receive( :open_id_authentication )
        post :create, :openid_identifier => 'foo'
      end
      
      it "should call authenticate_open_id" do
        @controller.should_receive(:authenticate_with_open_id).with(
            'foo.myopenid.com', 
            :required => [ :email ], 
            :optional => [ :nickname, :fullname ]
            )
        post :create, :openid_identifier => 'foo.myopenid.com'
      end
      
      describe "when open_id authentication fails" do
        it "should call failed_openid_authentication" do
          result = mock_model(OpenIdAuthentication::Result, { :successful? => false, :message => 'fail' })
          @controller.should_receive(:authenticate_with_open_id).with(
              'foo.myopenid.com', 
              :required => [ :email ], 
              :optional => [ :nickname, :fullname ]
              ).and_yield( result, 'foo.myopenid.com', OpenID::SReg::Request.new )
          @controller.should_receive(:failed_openid_authentication)
          post :create, :openid_identifier => 'foo.myopenid.com'
        end
      end
      
      describe "when open_id authentication succeeds" do
        it "should call successful_openid_authentication" do
          result = mock_model(OpenIdAuthentication::Result, { :successful? => true, :message => 'pass' })
          @controller.should_receive(:authenticate_with_open_id).with(
              'foo.myopenid.com', 
              :required => [ :email ], 
              :optional => [ :nickname, :fullname ]
              ).and_yield( result, 'foo.myopenid.com', OpenID::SReg::Request.new )
          @controller.should_receive(:successful_openid_authentication)
          post :create, :openid_identifier => 'foo.myopenid.com'
        end
      end
      
    end

    describe 'when openid_identifier not set' do
      it "should call non_open_id_create" do
        @controller.should_receive(:non_open_id_create)
        post :create
      end
    end
    
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
  
  describe "when an email is entered" do
    
    it "should call email_authentication" do
      @controller.should_receive(:using_open_id?).and_return(false)
      @controller.should_receive(:email_authentication)
      post :create, :openid_identifier => 'foo@myopenid.com'
    end
    
    describe "authenticating a new user" do
      it "should call open_id_authentication if the email could be translated with EAUT" do
        @controller.should_receive(:get_openid_for_email).with( 'foo@myopenid.com', :use_fallback_service => false ).and_return('foo.myopenid.com')
        @controller.should_receive(:open_id_authentication)
        @controller.params = {}
        @controller.params[:openid_identifier] = 'foo@myopenid.com'
        @controller.send( 'authenticate_new_user' )
      end

      it "should call non_open_id_create if the email could NOT be translated with EAUT" do
        @controller.should_receive(:get_openid_for_email).with( 'foo@myopenid.com', :use_fallback_service => false ).and_return(nil)
        @controller.should_receive(:non_open_id_create)
        @controller.params = {}
        @controller.params[:openid_identifier] = 'foo@myopenid.com'
        @controller.send( 'authenticate_new_user' )
      end
    end
    
    describe "authenticating an existing user" do
      it "should call open_id_authentication when an OpenId exists for the user" do
        OpenId.should_receive(:find_by_user_id).with( 1 ).and_return( mock_model(OpenId, :openid_url => 'foo.myopenid.com') )
        @controller.should_receive(:open_id_authentication)
        @controller.params = {}
        @controller.send( 'authenticate_existing_user', mock_user( :id => 1 ) )
      end

      it "should call non_open_id_create when an OpenId DOES NOT exist for the user" do
        OpenId.should_receive(:find_by_user_id).with( 1 ).and_return( nil )
        @controller.should_receive(:non_open_id_create)
        @controller.params = {}
        @controller.send( 'authenticate_existing_user', mock_user( :id => 1 ) )
      end
    end
    
  end
end


