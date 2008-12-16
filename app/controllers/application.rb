# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  include BeforeFilterRequirements
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  if RAILS_ENV == 'production'
    protect_from_forgery :secret => APP_CONFIG['settings']['forgery_secret']
  else
    protect_from_forgery
  end
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password, :password_confirmation, :old_password
  
  before_filter :load_user
  
  private
  
    def load_user
      @user_session = UserSession.find
      @current_user = @user_session && @user_session.record
    end
  
    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  
end
