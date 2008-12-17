require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module BeforeFilterBehaviors
  
  shared_examples_for "a controller with before_filters" do
    
    describe "with actions that require a user to be logged in" do
      it "should handle missing user" do
        test_before_filter( :require_user )
      end
    end

    describe "with actions that require a user NOT to be logged in" do
      it "should handle a user being logged in" do
        login_as(mock_user)
        test_before_filter( :require_no_user )
      end
    end

    describe "with actions which require an active user" do
      it "should handle inactive user" do      
        login_as(mock_user(:active? => false))
        test_before_filter( :require_active_user )
      end
    end
    
  end
  
end