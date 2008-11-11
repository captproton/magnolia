module AuthenticationProviderSpecHelper
  
  def valid_provider_attributes( attributes={} )
    attributes.merge( {
      :name => "value for name",
      :label => "value for label",
      :logo => "logo.png",
      :button => "button.png",
      :description => "value for description",
      :active => false,
      :type => 'OpenIdProvider',
      :display_sequence => "1"
    } )
  end
  
end
