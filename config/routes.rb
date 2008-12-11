ActionController::Routing::Routes.draw do |map|

  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.login '/login', :controller => 'user_sessions', :action => 'new'
	map.signup '/signup', :controller => 'pages', :action => 'show', :page => 'prelogin'
  
  map.resources :users
  map.resource :user_session
  map.resource :password
  map.resource :third_party_registration
  map.resources :user_activations
  
	# ==================
	# = Administration =
	# ==================
  # map.namespace :admin do |admin|      
  # end
  
  map.validate_screen_name 'registration/check_screen_name', :controller => 'ajax_validations', :action => 'validate_screen_name'
  map.validate_email 'registration/check_email', :controller => 'ajax_validations', :action => 'validate_email'

  map.tos 'tos', :controller => 'pages', :action => 'show', :page => 'tos'
  map.privacy 'privacy', :controller => 'pages', :action => 'show', :page => 'privacy'
  map.orientation 'orientation', :controller => 'pages', :action => 'show', :page => 'orientation'
	map.root :controller => 'pages', :action => 'show', :page => 'home'
	
	map.connect '*page' , :controller => 'pages' , :action => 'show'

end
