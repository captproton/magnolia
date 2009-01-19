module BeforeFilterRequirements
  
  LOGGED_IN_ERROR_MESSAGE = 'You must be logged in to access the page you requested.'
  LOGGED_OUT_ERROR_MESSAGE = 'You must be logged out to access the page you requested.'
  
  private
  
    def require_user
      unless @current_user
        store_location
        flash[:notice] = LOGGED_IN_ERROR_MESSAGE
        redirect_to login_url
        return false
      end
      true
    end

    def require_no_user
      if @current_user
        store_location
        flash[:notice] = LOGGED_OUT_ERROR_MESSAGE
        redirect_to @current_user
        return false
      end
      true
    end
  
    def require_active_user
      return false unless require_user
      unless @current_user.active?
        redirect_to user_activation_path(@current_user)
        return false
      end
      true
    end
  
end