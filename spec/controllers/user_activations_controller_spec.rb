require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require File.expand_path(File.dirname(__FILE__) + '/shared/before_filter_behaviors_spec' )
include BeforeFilterBehaviors

describe UserActivationsController do

  it_should_behave_like "a controller with before_filters"

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

  end

  describe "responding to GET show" do
    
    describe "when not logged in" do
      
      before(:each) do        
        login_as( mock_user )
      end
      
      it "should call update" do
        @controller.should_receive(:update)
        get :show, :id => 'p_token'
      end
      
    end
    
  end
  
  describe "responding to GET edit" do
    
    describe "when not logged in" do
      
      before(:each) do        
        login_as( mock_user )
      end
      
      it "should call render the new view" do
        get :edit, :id => 'p_token'
        response.should render_template('new')
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
  end

  
  describe "responding to DELETE destroy" do
    
    describe "when logged in" do
      
      before(:each) do        
        login_as( mock_user( :perishable_token => 'p_token' ) )
        mock_user.stub!(:update_attribute)
        mock_user.stub!(:reset_perishable_token!)
        mock_user.stub!(:destroy)
        mock_user_session.stub!(:destroy)
      end
      
      it "should destroy the user_session" do
        mock_user_session.should_receive(:destroy)
        delete :destroy, :id => '1'
      end
      
      it "should destroy the user" do
        mock_user.should_receive(:destroy)
        delete :destroy, :id => '1'
      end
      
      it "should redirect to the signup page" do
        delete :destroy, :id => '1'
        response.should redirect_to( new_user_path )
      end
        
    end
  end
    
end
