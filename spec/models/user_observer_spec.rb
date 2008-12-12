require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include AuthenticationSpecHelper

describe UserObserver do
  
  it "should send an activation notice after a User is created" do
    User.with_observers(:user_observer) do    
      UserNotifier.should_receive(:deliver_signup_notice)
      User.create valid_user_attributes 
    end
  end
  
  it "should reset the User's perishable token" do
    User.with_observers(:user_observer) do
      mock_user( valid_user_attributes ).should_receive(:reset_perishable_token!)
      UserObserver.send(:new).after_create( mock_user )
    end
  end
  
  it "should not send activation if the user is already active" do
    User.with_observers(:user_observer) do    
      mock_user( valid_user_attributes( :active => true ) ).should_not_receive(:reset_perishable_token!)
      UserNotifier.should_not_receive(:deliver_signup_notice)
      UserObserver.send(:new).after_create( mock_user )
    end
  end
  
end