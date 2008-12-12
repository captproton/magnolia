require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordResetsController do
  
  describe "responding to GET new" do
    
    describe "when not logged in" do
      
      it "should render the new template" do
        get :new
        response.should render_template( 'new' )
      end
    end
    
    describe "when logged in" do
      it "should redirect to login page" do    
        login_as(mock_user)
        get :new
        response.should redirect_to( user_path(mock_user) )
        flash[:notice].should ==('You must be logged out to access this page.')
      end
    end
  end

  describe "responding to POST create" do
    
    describe "when not logged in" do
      
      before(:each) do
        User.stub!(:find_by_email).and_return( mock_user )
        mock_user.stub!(:deliver_password_reset_instructions!)
      end
      
      describe "and identifier is an email" do
        it "should look the user up by email" do
          User.should_receive(:find_by_email).and_return( mock_user )
          post :create, :identifier => 'foo@foo.com'
        end
      end
      
      describe "and identifier is not an email" do
        it "should look the user up by screen_name" do
          User.should_receive(:find_by_screen_name).and_return( mock_user )
          post :create, :identifier => 'foo'
        end
      end
      describe "and a User is found for the given identifier" do

        it "should send the password reset instructions" do
          mock_user.should_receive(:deliver_password_reset_instructions!)
          post :create, :identifier => 'foo@foo.com'
        end
        
        it "should render a flash notice that instructions were sent" do
        post :create, :identifier => 'foo@foo.com'
          flash[:notice].should match(/Instructions to reset your password/)
        end
        
        it "should redirect to the login page" do
        post :create, :identifier => 'foo@foo.com'
          response.should redirect_to( login_url )
        end
      end

      describe "and no User was found for the given identifier" do
        
        before(:each) do
          User.stub!(:find_by_screen_name).and_return( nil )
        end

        it "should render a flash notice that no corresponding User was found" do
          post :create, :identifier => 'foo'
          flash[:notice].should ==('No user with that email address or screen name was found.')
        end
        
        it "should re-render the new template" do
          post :create, :identifier => 'foo'
          response.should render_template( 'new' )
        end
      end
    end
    
    describe "when logged in" do
      it "should redirect to login page" do    
        login_as(mock_user)
        get :new
        response.should redirect_to( user_path(mock_user) )
        flash[:notice].should ==('You must be logged out to access this page.')
      end
    end
  end

  describe "responding to GET edit" do
    
    describe "when not logged in" do
      
      describe "and a User was found for the token" do

        it "should render the edit template" do
          @controller.stub!(:load_user_using_perishable_token).and_return(mock_user)
          get :edit, :id => 'p_token'
          response.should render_template( 'edit' )
        end
      end
      
      describe "and a User could not be found for the token" do
        before(:each) do
          User.should_receive( :find_using_perishable_token ).with('p_token').and_return(nil)
        end

        it "should flash could not find account notice" do
          get :edit, :id => 'p_token'
          flash[:notice].should match( /We're sorry, but we could not locate your account./ )
        end

        it "should redirect to reset password page" do
          get :edit, :id => 'p_token'
          response.should redirect_to( new_password_reset_url )          
        end
      end
    end
    
    describe "when logged in" do
      it "should redirect to login page" do    
        login_as(mock_user)
        get :edit, :id => 'p_token'
        response.should redirect_to( user_path(mock_user) )
        flash[:notice].should ==('You must be logged out to access this page.')
      end
    end
  end
  
  describe "responding to PUT update" do
    
    describe "when not logged in" do
      
      describe "and a User was found for the token" do

        before(:each) do
          User.stub!(:find_using_perishable_token).with('p_token').and_return(mock_user)  
          mock_user.stub!(:password=)
          mock_user.stub!(:password_confirmation=)
        end
        
        describe "given valid parameters" do
          
          before(:each) do
            mock_user.stub!(:save).and_return(:true)
            UserSession.stub!(:create)
          end
          
          it "should update the user's password" do
            mock_user.should_receive(:password=)
            mock_user.should_receive(:password_confirmation=)
            mock_user.should_receive(:save).and_return(:true)
            put :update, :id => 'p_token', :user => { :password => 'foo', :password_confirmation => 'foo' }
          end
          
          it "should log the User in" do
            UserSession.should_receive(:create).with(mock_user).and_return(mock_user_session)
            put :update, :id => 'p_token', :user => { :password => 'foo', :password_confirmation => 'foo' }
          end
                    
          it "should flash a confirmation message" do
            put :update, :id => 'p_token', :user => { :password => 'foo', :password_confirmation => 'foo' }
            flash[:notice].should ==( 'Password successfully updated' )
          end
          
          it "should redirect to the user's home page" do
            put :update, :id => 'p_token', :user => { :password => 'foo', :password_confirmation => 'foo' }
            response.should redirect_to( user_path(mock_user) )
          end

        end
        
        describe "given invalid parameters" do
          it "should re-render the edit action" do
            mock_user.stub!(:save).and_return(false)
            put :update, :id => 'p_token', :user => { :password => 'foo', :password_confirmation => 'foo' }
            response.should render_template( 'edit' )
          end
        end
      end
      
      describe "and a User could not be found for the token" do
        
        before(:each) do
          User.should_receive( :find_using_perishable_token ).with('p_token').and_return(nil)
        end
        
        it "should flash could not find account notice" do
          put :update, :id => 'p_token'
          flash[:notice].should match( /We're sorry, but we could not locate your account./ )
        end
        
        it "should redirect to reset password page" do
          put :update, :id => 'p_token'
          response.should redirect_to( new_password_reset_url )          
        end
      end
    end
    
    describe "when logged in" do
      it "should redirect to login page" do    
        login_as(mock_user)
        get :edit, :id => 'p_token'
        response.should redirect_to( user_path(mock_user) )
        flash[:notice].should ==('You must be logged out to access this page.')
      end
    end
  end

  
end
