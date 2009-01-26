require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do
  
  class FakeController < ApplicationController
    def index; render :text => "fakes"; end
  end
  
  controller_name :fake
  
  before(:each) do
    ActionController::Routing::Routes.add_named_route( 'fakies', '/fakies', :controller => 'fake', :action => 'index' )
  end
  
  it "should call load_facebook_user if no UserSession was found" do
    UserSession.should_receive(:find).and_return(nil)
    controller.should_receive( :load_facebook_user )
    get :index
  end
  
  describe "with a facebook_session" do
    
    before(:each) do
      UserSession.should_receive(:find).and_return(nil)
      facebook_session = mock_model( Facebooker::Session, :secured? => true, :user => mock_user )
      controller.stub!( :facebook_session ).and_return( facebook_session )
      controller.should_receive( :request_is_facebook_tab? ).and_return(false)
    end
    
    it "should assign the current_user when there is an associated facebook_identity" do
      face_id = mock_model( FacebookIdentity )
      FacebookIdentity.should_receive( :find_by_facebook_id ).and_return( face_id )
      face_id.should_receive( :user ).and_return( mock_user )
      get :index
      assigns[:current_user].should ==( mock_user )
    end

    it "should redirect to the registration page when there is NOT an associated facebook_identity" do
      FacebookIdentity.should_receive( :find_by_facebook_id )
      get :index
      
      # this failed with redirect_to(:action => :edit, :controller => :third_party_registrations)
      response.should redirect_to( '/third_party_registration/edit' )
    end
    
  end
  
end
