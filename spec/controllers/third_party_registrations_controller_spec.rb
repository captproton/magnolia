require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require File.expand_path(File.dirname(__FILE__) + '/shared/before_filter_behaviors_spec' )
include BeforeFilterBehaviors

describe ThirdPartyRegistrationsController do

  it_should_behave_like "a controller with before_filters"

  describe "responding to GET new" do
    
    describe "when not logged in" do
      
      it "should expose the openid_identifier if one was provided in the request" do
        get :new, :openid_identifier => 'foo.myopenid.com'
        assigns[:openid_identifier].should ==('foo.myopenid.com')
      end
      
      it 'should render the new form' do        
        get :new
        response.should render_template('new')
      end
    end

  end
  
  describe "responding to PUT update" do
    
    describe "without an authenticated openid_identifier" do
      
      it "should redirect to the new form if an openid_identifier has not been authenticated" do
        put :update
        response.should redirect_to(new_third_party_registration_url)
      end
    end
    
    describe "with an authenticated openid_identifier" do
      
      before(:each) do        
        @controller.session[:openid_identifier] = 'foo.myopenid.com'
      end
      
      describe "and valid parameters" do
        
        before(:each) do
          mock_user(:save => true, :open_ids => [], :active= => true)
          User.stub!(:new).with({'these' => 'params'}).and_return(mock_user)
          UserSession.stub!(:create).and_return( mock_user_session( :record => mock_user ) )
        end
        
        it "should expose a newly created user" do
          put :update, :user => {:these => 'params'}
          assigns(:user).should equal(mock_user)
        end
        
        it "should create an OpenId for the new user" do
          open_id = mock_model(OpenId)
          OpenId.should_receive(:new).with( :openid_identifier => @controller.session[:openid_identifier] ).and_return( open_id )
          put :update, :user => {:these => 'params'}
          assigns(:user).open_ids.should include(open_id)
        end
        
        it "should clear the openid_identifier from the session" do
          put :update, :user => {:these => 'params'}
          @controller.session[:openid_identifier].should be_nil
        end

        it "should log the user in" do
          UserSession.should_receive(:create).with(mock_user).and_return(mock_user_session)          
          put :update, :user => {:these => 'params'}
        end
        
        it "should render the user_activation page" do
          put :update, :user => {:these => 'params'}, :commit => 'home'
          response.should render_template( 'user_activations/new' )
        end
        
      end
      
      describe "and invalid params" do

        before(:each) do
          User.stub!(:new).and_return( mock_user( :save => false, :open_ids => [], :active= => true  ) )
        end
        
        it "should expose a newly created but unsaved user as @user" do
          post :update, :user => {:these => 'params'}
          assigns(:user).should equal(mock_user)
        end

        it "should re-render the 'edit' template" do
          post :update, :user => {}
          response.should render_template('edit')
        end
      end
      
    end
  end # PUT update

end
