require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::AuthenticationProvidersController do

  def mock_authentication_provider(stubs={})
    @mock_authentication_provider ||= mock_model(AuthenticationProvider, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all admin_authentication_providers as @admin_authentication_providers" do
      AuthenticationProvider.should_receive(:find).with(:all).and_return([mock_authentication_provider])
      get :index
      assigns[:authentication_providers].should == [mock_authentication_provider]
    end

    describe "with mime type of xml" do
  
      it "should render all admin_authentication_providers as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        AuthenticationProvider.should_receive(:find).with(:all).and_return(authentication_providers = mock("Array of AuthenticationProviders"))
        authentication_providers.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested authentication_provider as @authentication_provider" do
      AuthenticationProvider.should_receive(:find).with("37").and_return(mock_authentication_provider)
      get :show, :id => "37"
      assigns[:authentication_provider].should equal(mock_authentication_provider)
    end
    
    describe "with mime type of xml" do

      it "should render the requested authentication_provider as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        AuthenticationProvider.should_receive(:find).with("37").and_return(mock_authentication_provider)
        mock_authentication_provider.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new authentication_provider as @authentication_provider" do
      AuthenticationProvider.should_receive(:new).and_return(mock_authentication_provider)
      get :new
      assigns[:authentication_provider].should equal(mock_authentication_provider)
    end

  end

  describe "responding to GET edit" do
  
    before(:each) do
      @auth_providers = []
      5.times do |n|
        ap = mock_model( AuthenticationProvider, {:id => n} )
        ap.stub!(:[]).with('type').and_return('OpenIdProvider')
        @auth_providers << ap
      end
      AuthenticationProvider.should_receive(:find).with(:all).and_return(@auth_providers)
    end
    
    it "should expose the requested authentication_provider as @authentication_provider" do
      get :edit, :id => "2"
      assigns[:authentication_provider].should equal(@auth_providers[2])
    end

    it "should expose a collection of the authentication_provider types" do
      get :edit, :id => "2"
      assigns[:authentication_provider_types].should ==(['OpenIdProvider'])
    end
    
  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created authentication_provider as @authentication_provider" do
        AuthenticationProvider.should_receive(:new).with({'these' => 'params'}).and_return(mock_authentication_provider(:save => true))
        post :create, :authentication_provider => {:these => 'params'}
        assigns(:authentication_provider).should equal(mock_authentication_provider)
      end

      it "should redirect to the created authentication_provider" do
        AuthenticationProvider.stub!(:new).and_return(mock_authentication_provider(:save => true))
        post :create, :authentication_provider => {}
        response.should redirect_to(admin_authentication_provider_url(mock_authentication_provider))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved authentication_provider as @authentication_provider" do
        AuthenticationProvider.stub!(:new).with({'these' => 'params'}).and_return(mock_authentication_provider(:save => false))
        post :create, :authentication_provider => {:these => 'params'}
        assigns(:authentication_provider).should equal(mock_authentication_provider)
      end

      it "should re-render the 'new' template" do
        AuthenticationProvider.stub!(:new).and_return(mock_authentication_provider(:save => false))
        post :create, :authentication_provider => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested authentication_provider" do
        AuthenticationProvider.should_receive(:find).with("37").and_return(mock_authentication_provider)
        mock_authentication_provider.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :authentication_provider => {:these => 'params'}
      end

      it "should expose the requested authentication_provider as @authentication_provider" do
        AuthenticationProvider.stub!(:find).and_return(mock_authentication_provider( :update_attributes => true, :update_attribute => true ) )
        put :update, :id => "1", :authentication_provider => {:type => 'OpenIdProvider'}
        assigns(:authentication_provider).should equal(mock_authentication_provider)
      end

      it "should redirect to the authentication_provider" do
        AuthenticationProvider.stub!(:find).and_return(mock_authentication_provider( :update_attributes => true, :update_attribute => true ) )
        put :update, :id => "1", :authentication_provider => {:type => 'OpenIdProvider'}
        response.should redirect_to(admin_authentication_provider_url(mock_authentication_provider))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested authentication_provider" do
        AuthenticationProvider.should_receive(:find).with("37").and_return(mock_authentication_provider)
        mock_authentication_provider.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :authentication_provider => {:these => 'params'}
      end

      it "should expose the authentication_provider as @authentication_provider" do
        AuthenticationProvider.stub!(:find).and_return(mock_authentication_provider(:update_attributes => false))
        put :update, :id => "1"
        assigns(:authentication_provider).should equal(mock_authentication_provider)
      end

      it "should re-render the 'edit' template" do
        AuthenticationProvider.stub!(:find).and_return(mock_authentication_provider(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested authentication_provider" do
      AuthenticationProvider.should_receive(:find).with("37").and_return(mock_authentication_provider)
      mock_authentication_provider.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the admin_authentication_providers list" do
      AuthenticationProvider.stub!(:find).and_return(mock_authentication_provider(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(admin_authentication_providers_url)
    end

  end

end
