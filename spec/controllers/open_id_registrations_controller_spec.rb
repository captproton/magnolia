require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require File.expand_path(File.dirname(__FILE__) + '/shared/before_filter_behaviors_spec' )
include BeforeFilterBehaviors

describe OpenIdRegistrationsController do

  it_should_behave_like "a controller with before_filters"
  
  describe "responding to POST create" do
    
    describe "with an open_id_identifier" do
      
      describe "which is valid and not an email" do
        it "should do OpenId authentication" do
          @controller.should_receive(:using_open_id?).and_return(true)
          @controller.should_receive(:open_id_authentication)
          post :create, :openid_identifier => 'foo.myopenid.com'
        end
      end
      
      describe "which is an email" do
        
        describe "that is already in use" do
          
          before(:each) do              
            @controller.should_receive(:using_open_id?).and_return(false)
          end
          
          it "should return an error message" do
            User.should_receive(:find_by_email).with('foo@myopenid.com').and_return(mock_user)
            post :create, :openid_identifier => 'foo@myopenid.com'
            flash[:error].should match( /email/ )
          end
          
          it "should re-render the new form" do            
            User.should_receive(:find_by_email).with('foo@myopenid.com').and_return(mock_user)
            post :create, :openid_identifier => 'foo@myopenid.com'
            response.should render_template('new')
          end
        end
        
        describe "that is not in use" do
          
          it "should try to translate the email to an OpenId" do
            @controller.should_receive(:get_openid_for_email).with( 'foo@myopenid.com', :use_fallback_service => false )
            post :create, :openid_identifier => 'foo@myopenid.com'
          end
          
          it "should do OpenId authentication if the email could be translated to an OpenId" do
            @controller.should_receive(:get_openid_for_email).and_return('foo.myopenid.com')
            @controller.should_receive(:open_id_authentication)
            post :create, :openid_identifier => 'foo@myopenid.com'
          end
          
          it "should redirect to un/pw registration if the email could NOT be translated to an OpenId" do
            @controller.should_receive(:get_openid_for_email).and_return(nil)
            post :create, :openid_identifier => 'foo@myopenid.com'
            response.should redirect_to(new_user_path)
          end 
        end
        
      end # with email
    end # with openid_identifier
    
    describe "with OpenId complete callback" do
      
      describe "successful" do
        
        before(:each) do
          result = mock_model( OpenIdAuthentication::Result, { :successful? => true, :message => 'pass' } )
          sreg = mock_model( OpenID::SReg::Request )
          sreg.stub!(:[]).with( 'email' ).and_return( 'foo@myopenid.com' )
          sreg.stub!(:[]).with( 'nickname' ).and_return( 'foo' )
          @controller.should_receive(:authenticate_with_open_id).with(
              'foo.myopenid.com', 
              :required => [ :email ], 
              :optional => [ :nickname ]
              ).and_yield( result, 'foo.myopenid.com', sreg )
        end
        
        describe "but OpenId is already in use" do
          
          before(:each) do
            User.should_receive( :find_by_open_id ).with( 'foo.myopenid.com' ).and_return( mock_user )
          end
          
          it "should alert user that OpenId is in use" do
            post :create, :openid_identifier => 'foo.myopenid.com'
            flash[:error].should match( /in use/ )
          end
          
          it "should re-render to the new page" do
            post :create, :openid_identifier => 'foo.myopenid.com'
            response.should render_template( 'new' )
          end
          
        end
        
        describe "and OpenId is not in use" do
          
          before(:each) do
            User.should_receive( :find_by_open_id ).with( 'foo.myopenid.com' ).and_return( nil )
          end
          
          it "should set the openid_identifier in the session" do            
            post :create, :openid_identifier => 'foo.myopenid.com'
            @controller.session[:openid_identifier].should ==('foo.myopenid.com')
          end
          
          it "should redirect to edit action with user params" do
            post :create, :openid_identifier => 'foo.myopenid.com'
            response.should redirect_to( edit_third_party_registration_url( :user => { :screen_name => 'foo', :email => 'foo@myopenid.com' } ) )            
          end
        end
      
      end # successful
    end # with OpenId complete callback
    
  end # POST create

end
