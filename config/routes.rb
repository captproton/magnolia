ActionController::Routing::Routes.draw do |map|

  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.login '/login', :controller => 'user_sessions', :action => 'new'
	map.signup '/signup', :controller => 'users', :action => 'new'
  
  map.resources :users
  map.resource :user_session
  map.resource :password
  
	# ==================
	# = Administration =
	# ==================
  map.namespace :admin do |admin|      
		admin.resources :authentication_providers
  end
  
	map.root :controller => 'pages'

end
