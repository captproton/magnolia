require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require File.expand_path(File.dirname(__FILE__) + '/shared/before_filter_behaviors_spec' )
include BeforeFilterBehaviors

describe UserSessionsController do
  
  it_should_behave_like "a controller with before_filters"

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
       
      it "should expose the logical section as @section == 'authentication'" do        
        get :new
        assigns[:section].should ==('authentication')
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

        before(:each) do
          UserSession.should_receive(:find).and_return(nil)
          mock_user_session.should_receive(:save).and_return(false)
          UserSession.stub!(:new).and_return(mock_user_session(:save => false))
        end
        
        it "should re-render the 'new' template" do
          post :create, :user_session => {}
          response.should render_template('new')
        end
      
        it "should set the show password form flag" do
          post :create, :user_session => {}
          assigns[:show_password_form].should ==(true)
        end
        
      end
    end    
  end
  
  describe "responding to DELETE" do
    
    describe "when logged in" do
      
      before(:each) do        
        UserSession.should_receive(:find).and_return(mock_user_session)
        mock_user_session.should_receive(:record).and_return(mock_user)
        mock_user_session.should_receive(:destroy).and_return(true)
      end
      
      it "should destroy the user_session" do
        post :destroy
        flash[:notice].should ==('Logout successful!')
      end

      it "should redirect to the login page" do
        post :destroy
        response.should redirect_to( login_url )
      end
      
      it "should destroy any facebook cookies" do
        facebook_key = 'facebook_key'
        cookies = mock('cookies')
        controller.stub!(:cookies).and_return(cookies)
        
        cookies.stub!(:keys).and_return([facebook_key])
        Facebooker.stub!(:api_key).and_return(facebook_key)
        cookies.should_receive(:delete).with(facebook_key)
        
        post :destroy
      end
    
    end    
  end
end
