require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserNotifier do
  
  context 'activation email' do

    before(:each) do
      @user = mock_user( :email => 'foo@new.com', :perishable_token => 'p_token' )
    end
    
    it "should contain the activation code" do
      mail = UserNotifier.deliver_signup_notice(@user)
      mail.body.should match( Regexp.new( @user.perishable_token ) )
    end
    
    it "should be to the user" do      
      mail = UserNotifier.deliver_signup_notice(@user)
      mail.to.should include( "#{@user.email}" )
    end
    
    it "should be from support@" do      
      mail = UserNotifier.deliver_signup_notice(@user)
      mail.from.should include( "support@ma.gnolia.com" )
    end
    
  end
  
end