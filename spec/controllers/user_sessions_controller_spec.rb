require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionsController do


  describe "responding to GET new" do
    
    describe "when not logged in" do
      
      before(:each) do        
        UserSession.should_receive(:find).and_return(nil)
        UserSession.should_receive(:new).and_return(mock_user_session)
      end
      
      it "should expose a new user as @user" do
        get :new
        assigns[:user_session].should equal(mock_user_session)
      end
      
      it "should expose the collection of authentication providers as @auth_providers" do
        aps = [1, 2, 3, 4]
        AuthenticationProvider.should_receive(:active).and_return(aps)
        get :new
        assigns[:auth_providers].should equal(aps)
      end
        
      it "should expose the authentication method choice of the user as @preferred_auth_provider" do
        get :new
        assigns[:preferred_auth_provider].should_not be_nil
      end
      
      it "should set @preferred_auth_provider to object with name=='openid' if no auth_method cookie is set" do
        get :new
        assigns[:preferred_auth_provider].name.should ==('openid')
      end
      
      it "should set @preferred_auth_provider object name to cookie value when cookie is set" do
        request.cookies['Magnolia_Auth_Method'] = CGI::Cookie.new('Magnolia_Auth_Method', 'cookie value')
        get :new
        assigns[:preferred_auth_provider].name.should ==('cookie value')
      end
        
      it "should expose the logical section as @section == 'authentication'" do        
        get :new
        assigns[:section].should ==('authentication')
      end
      
    end
    
    describe "when logged in" do
      it "should redirect to user home page" do        
        login_as(mock_user)
        get :new
        response.should redirect_to( user_path(mock_user) )
        flash[:notice].should ==('You must be logged out to access this page.')
      end
    end
  end

  describe "responding to POST create" do
    
    describe "when not logged in" do
      describe "with valid params" do
      
        it "should create a user_session" do
          UserSession.should_receive(:find).and_return(nil)
          mock_user_session.should_receive(:save).and_return(true)
          UserSession.should_receive(:new).with({'these' => 'params'}).and_return(mock_user_session)
          post :create, :user_session => {:these => 'params'}
        end

        it "should redirect to the home page" do
          UserSession.should_receive(:find).and_return(nil)
          UserSession.stub!(:new).and_return(mock_user_session(:save => true))
          post :create, :user_session => {}
          response.should redirect_to( root_url )
        end
      
      end
    
      describe "with invalid params" do

        it "should re-render the 'new' template" do
          UserSession.should_receive(:find).and_return(nil)
          mock_user_session.should_receive(:save).and_return(false)
          UserSession.stub!(:new).and_return(mock_user_session(:save => false))
          post :create, :user_session => {}
          response.should render_template('new')
        end
      
      end
    end
    
    describe "when logged in" do
      it "should redirect to user home page" do        
        login_as(mock_user)
        post :create
        response.should redirect_to( user_path(mock_user) )
        flash[:notice].should ==('You must be logged out to access this page.')
      end
    end
    
  end
  
  describe "responding to DELETE" do
    
    describe "when not logged in" do
      
        it "should destroy the user_session" do
          UserSession.should_receive(:find).and_return(mock_user_session)
          mock_user_session.should_receive(:record).and_return(mock_user)
          mock_user_session.should_receive(:destroy).and_return(true)
          post :destroy
          flash[:notice].should ==('Logout successful!')
        end

        it "should redirect to the login page" do
          UserSession.should_receive(:find).and_return(mock_user_session)
          mock_user_session.should_receive(:record).and_return(mock_user)
          mock_user_session.should_receive(:destroy).and_return(true)
          post :destroy
          response.should redirect_to( login_url )
        end
    
    end
    
    describe "when logged in" do
      it "should redirect to login page" do       
        delete :destroy
        response.should redirect_to( login_url )
        flash[:notice].should ==('You must be logged in to access this page.')
      end
    end
    
  end
end
