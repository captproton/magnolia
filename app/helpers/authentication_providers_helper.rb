module AuthenticationProvidersHelper

  def select_for_signin_method( auth_providers )
    select( 
  		:preferred_auth_provider, 
  		:name, 
  		auth_providers.collect { |ap| [ ap.name, ap.name.downcase ] }.insert( 0, ['Select sign in method', ''] )
  		)
  end  
  
end
