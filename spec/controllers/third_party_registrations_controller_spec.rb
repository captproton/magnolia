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
  
  describe "responding to POST create" do
    
    describe "with an open_id_identifier" do
      
      describe "which is valid and not an email" do
        it "should do OpenId authentication" do
          @controller.should_receive(:using_open_id?).and_return(true)
          @controller.should_receive(:open_id_authentication)
          post :create, :openid_identifier => 'foo.myopenid.com'
        end
      end
      
      describe "which is an email" do
        
        describe "that is already in use" do
          
          before(:each) do              
            @controller.should_receive(:using_open_id?).and_return(false)
          end
          
          it "should return an error message" do
            User.should_receive(:find_by_email).with('foo@myopenid.com').and_return(mock_user)
            post :create, :openid_identifier => 'foo@myopenid.com'
            flash[:error].should match( /email/ )
          end
          
          it "should re-render the new form" do            
            User.should_receive(:find_by_email).with('foo@myopenid.com').and_return(mock_user)
            post :create, :openid_identifier => 'foo@myopenid.com'
            response.should render_template('new')
          end
        end
        
        describe "that is not in use" do
          
          it "should try to translate the email to an OpenId" do
            @controller.should_receive(:get_openid_for_email).with( 'foo@myopenid.com', :use_fallback_service => false )
            post :create, :openid_identifier => 'foo@myopenid.com'
          end
          
          it "should do OpenId authentication if the email could be translated to an OpenId" do
            @controller.should_receive(:get_openid_for_email).and_return('foo.myopenid.com')
            @controller.should_receive(:open_id_authentication)
            post :create, :openid_identifier => 'foo@myopenid.com'
          end
          
          it "should redirect to un/pw registration if the email could NOT be translated to an OpenId" do
            @controller.should_receive(:get_openid_for_email).and_return(nil)
            post :create, :openid_identifier => 'foo@myopenid.com'
            response.should redirect_to(new_user_path)
          end 
        end
        
      end # with email
    end # with openid_identifier
    
    describe "with OpenId complete callback" do
      
      describe "successful" do
        
        before(:each) do
          result = mock_model( OpenIdAuthentication::Result, { :successful? => true, :message => 'pass' } )
          sreg = mock_model( OpenID::SReg::Request )
          sreg.stub!(:[]).with( 'email' ).and_return( 'foo@myopenid.com' )
          sreg.stub!(:[]).with( 'nickname' ).and_return( 'foo' )
          @controller.should_receive(:authenticate_with_open_id).with(
              'foo.myopenid.com', 
              :required => [ :email ], 
              :optional => [ :nickname ]
              ).and_yield( result, 'foo.myopenid.com', sreg )
        end
        
        describe "but OpenId is already in use" do
          
          before(:each) do
            User.should_receive( :find_by_open_id ).with( 'foo.myopenid.com' ).and_return( mock_user )
          end
          
          it "should alert user that OpenId is in use" do
            post :create, :openid_identifier => 'foo.myopenid.com'
            flash[:error].should match( /in use/ )
          end
          
          it "should re-render to the new page" do
            post :create, :openid_identifier => 'foo.myopenid.com'
            response.should render_template( 'new' )
          end
          
        end
        
        describe "and OpenId is not in use" do
          
          before(:each) do
            User.should_receive( :find_by_open_id ).with( 'foo.myopenid.com' ).and_return( nil )
          end
          
          it "should set the openid_identifier in the session" do            
            post :create, :openid_identifier => 'foo.myopenid.com'
            @controller.session[:openid_identifier].should ==('foo.myopenid.com')
          end
          
          it "should redirect to edit action with user params" do
            post :create, :openid_identifier => 'foo.myopenid.com'
            response.should redirect_to( edit_third_party_registration_url( :user => { :screen_name => 'foo', :email => 'foo@myopenid.com' } ) )            
          end
        end
      
      end # successful
    end # with OpenId complete callback
    
  end # POST create
  
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
          UserSession.stub!(:create).and_return(mock_user_session)
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
        
        it "should redirect to the user home page if Orientation was not selected" do
          put :update, :user => {:these => 'params'}, :commit => 'home'
          response.should redirect_to( user_url(mock_user) )
        end
        
        it "should redirect to the orientation page if Orientation was selected" do
          put :update, :user => {:these => 'params'}, :commit => 'orientation'
          response.should redirect_to( orientation_url )
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
  end # POST update

end
