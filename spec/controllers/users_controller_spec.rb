require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  
  describe "responding to GET index" do

    describe "when logged in" do

      before(:each) do
        login_as(mock_user)
      end
      
      it "should expose all users as @users" do
        User.should_receive(:find).with(:all).and_return([mock_user])
        get :index
        assigns[:users].should == [mock_user]
      end

      describe "with mime type of xml" do
  
        it "should render all users as xml" do
          request.env["HTTP_ACCEPT"] = "application/xml"
          User.should_receive(:find).with(:all).and_return(users = mock("Array of Users"))
          users.should_receive(:to_xml).and_return("generated XML")
          get :index
          response.body.should == "generated XML"
        end
    
      end
    end
    
    describe "when not logged in" do
      it "should redirect to login page" do       
        get :index
        response.should redirect_to( login_url )
        flash[:notice].should ==('You must be logged in to access this page.')
      end
    end
    
  end

  describe "responding to GET show" do

    describe "when logged in" do

      before(:each) do
        login_as(mock_user)
      end
      
      it "should expose the requested user as @user" do
        User.should_receive(:find).with("37").and_return(mock_user)
        get :show, :id => "37"
        assigns[:user].should equal(mock_user)
      end

      describe "with mime type of xml" do

        it "should render the requested user as xml" do
          request.env["HTTP_ACCEPT"] = "application/xml"
          User.should_receive(:find).with("37").and_return(mock_user)
          mock_user.should_receive(:to_xml).and_return("generated XML")
          get :show, :id => "37"
          response.body.should == "generated XML"
        end
      end
    end
    
    describe "when not logged in" do
      it "should redirect to login page" do       
        get :show, :id => '37'
        response.should redirect_to( login_url )
        flash[:notice].should ==('You must be logged in to access this page.')
      end
    end
  end

  describe "responding to GET new" do
    
    describe "when not logged in" do
      it "should expose a new user as @user" do
        User.should_receive(:new).and_return(mock_user)
        get :new
        assigns[:user].should equal(mock_user)
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
      
        it "should expose a newly created user as @user" do
          User.should_receive(:new).with({'these' => 'params'}).and_return(mock_user(:save => true))
          post :create, :user => {:these => 'params'}
          assigns(:user).should equal(mock_user)
        end

        it "should redirect to the created user" do
          User.stub!(:new).and_return(mock_user(:save => true))
          post :create, :user => {}
          response.should redirect_to(user_url(mock_user))
        end
      
      end
    
      describe "with invalid params" do

        it "should expose a newly created but unsaved user as @user" do
          User.stub!(:new).with({'these' => 'params'}).and_return(mock_user(:save => false))
          post :create, :user => {:these => 'params'}
          assigns(:user).should equal(mock_user)
        end

        it "should re-render the 'new' template" do
          User.stub!(:new).and_return(mock_user(:save => false))
          post :create, :user => {}
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

end
