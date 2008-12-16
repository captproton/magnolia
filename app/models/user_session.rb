class UserSession < Authlogic::Session::Base
  
  # see AuthLogic::Session::Config for more details
  cookie_key 'magnolia_credentials'
  session_key 'magnolia_session'
  login_field :email
  check_user_state = false
  
end
