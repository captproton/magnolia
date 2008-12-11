require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserActivationsController do

  describe "responding to GET new" do
    
    describe "when logged in" do
      
      before(:each) do        
        login_as(mock_user)
        UserNotifier.stub!(:signup_notice)
      end
      
      it "should send an activation email" do
        mock_user.stub!(:reset_perishable_token!)
        UserNotifier.should_receive(:deliver_signup_notice).with(mock_user)
        get :new
      end
      
      it "should reset the current user's perishable token" do
        UserNotifier.stub!(:deliver_signup_notice)
        mock_user.should_receive(:reset_perishable_token!)
        get :new
      end
      
    end
    
    describe "when not logged in" do
      it "should redirect to login page" do  
        get :new
        response.should redirect_to( login_path )
        flash[:notice].should ==('You must be logged in to access this page.')
      end
    end
  end

  describe "responding to GET edit" do
    
    describe "when not logged in" do
      
      before(:each) do        
        login_as( mock_user )
      end
      
      it "should call update" do
        @controller.should_receive(:update)
        get :edit, :id => 'p_token'
      end
      
    end
    
    describe "when not logged in" do
      it "should redirect to login page" do  
        get :edit, :id => 'p_token'
        response.should redirect_to( login_path )
        flash[:notice].should ==('You must be logged in to access this page.')
      end
    end
  end
  
  describe "responding to PUT update" do
    
    describe "when logged in" do
      
      before(:each) do        
        login_as( mock_user( :perishable_token => 'p_token' ) )
        mock_user.stub!(:update_attribute)
        mock_user.stub!(:reset_perishable_token!)
      end
      
      describe "with valid activation key" do
        
        it "should activate the user" do
          mock_user.should_receive(:update_attribute).with( :active, true )
          put :update, :id => 'p_token'
        end
        
        it "should reset the user's activation key" do
          mock_user.should_receive(:reset_perishable_token!)
          put :update, :id => 'p_token'
        end
        
        it "should render the update template" do
          put :update, :id => 'p_token'
          response.should render_template( 'update' )
        end
        
      end
      
      describe "with invalid activation key" do
        
        it "should render the error template" do          
          put :update, :id => 'p_token'
          response.should render_template( 'update' )
        end
        
        it "should not activate the user" do          
          mock_user.should_not_receive(:update_attribute)
        end
        
        it "should not reset the user's activation key" do          
          mock_user.should_not_receive(:reset_perishable_token!)
        end
        
      end
    end
    
    describe "when not logged in" do
      it "should redirect to login page" do  
        put :update, :id => 'p_token'
        response.should redirect_to( login_path )
        flash[:notice].should ==('You must be logged in to access this page.')
      end
    end
  end
  
end
