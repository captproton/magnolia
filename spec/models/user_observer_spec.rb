require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include AuthenticationSpecHelper

describe UserObserver do
  
  it "should send an activation notice after a User is created" do
    UserNotifier.should_receive(:deliver_signup_notice)
    User.create valid_user_attributes 
  end
  
end