# require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
#    
# def for_roles *roles
#   roles.each do |role|
#     before(:each) do
#       puts role.to_s
#     end
#     yield
#   end
# end
#    
# describe "DRY roles test" do
# 
#   describe "GET index" do
#     for_roles :admin, :sysadmin do |role|
#       it "..." do
#         puts 'in example'
#       end
#     end
#   end
# 
# end



# def remove_before(scope, &block)
#   parts = before_parts_from_scope(scope)
#   parts.delete(block)
# end
# 
# def remove_after(scope, &block)
#   parts = after_parts_from_scope(scope)
#   parts.delete(block)
# end
# 
# require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
# 
# def set_authentication_provider( auth_provider ) 
#   debugger
#   @ap = stub_model(auth_provider, {:name => 'authentication_provider'})
#   template.stub!(:auth_provider).and_return( @ap )
# end
# 
# describe "/authentication/_auth_provider.html.erb" do
#   include AuthenticationProvidersHelper
#   
#    for_each_variant :set_authentication_provider, OpenIdProvider, ClickpassProvider do |auth_provider|
#      it "should render the partial associated with the provider class" do       
#            debugger
#        template.should_receive(:render).with( 
#            :partial => "authentication/#{auth_provider.name.underscore}",
#            :object => @ap
#            )
#        render '/authentication/_auth_provider.html.erb'
#      end
#    end
#    
# end