class UserSession < Authlogic::Session::Base
  
  # see AuthLogic::Session::Config for more details
  cookie_key 'magnolia_credentials'
  session_key 'magnolia_session'
  login_field :screen_name
  remember_me true
  remember_me_for 1.year
  
end
