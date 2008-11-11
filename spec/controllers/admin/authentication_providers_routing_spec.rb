require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::AuthenticationProvidersController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "admin/authentication_providers", :action => "index").should == "/admin/authentication_providers"
    end
  
    it "should map #new" do
      route_for(:controller => "admin/authentication_providers", :action => "new").should == "/admin/authentication_providers/new"
    end
  
    it "should map #show" do
      route_for(:controller => "admin/authentication_providers", :action => "show", :id => 1).should == "/admin/authentication_providers/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "admin/authentication_providers", :action => "edit", :id => 1).should == "/admin/authentication_providers/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "admin/authentication_providers", :action => "update", :id => 1).should == "/admin/authentication_providers/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "admin/authentication_providers", :action => "destroy", :id => 1).should == "/admin/authentication_providers/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/admin/authentication_providers").should == {:controller => "admin/authentication_providers", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/admin/authentication_providers/new").should == {:controller => "admin/authentication_providers", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/admin/authentication_providers").should == {:controller => "admin/authentication_providers", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/admin/authentication_providers/1").should == {:controller => "admin/authentication_providers", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/admin/authentication_providers/1/edit").should == {:controller => "admin/authentication_providers", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/admin/authentication_providers/1").should == {:controller => "admin/authentication_providers", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/admin/authentication_providers/1").should == {:controller => "admin/authentication_providers", :action => "destroy", :id => "1"}
    end
  end
end
