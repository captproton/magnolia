ActionController::Routing::Routes.draw do |map|
  
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.login '/login', :controller => 'user_sessions', :action => 'new'
	map.signup '/signup', :controller => 'users', :action => 'new'
  
  map.resources :users
  map.resource :user_session
  
	map.root :controller => 'pages'

end
