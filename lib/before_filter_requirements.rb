module ActionRequirements
  
  private
  
    def require_user
      unless @current_user
        store_location
        flash[:notice] = 'You must be logged in to access this page.'
        redirect_to login_url
        return false
      end
    end

    def require_no_user
      if @current_user
        store_location
        flash[:notice] = 'You must be logged out to access this page.'
        redirect_to @current_user
        return false
      end
    end
  
    def require_active_user
      unless @current_user && @current_user.active
        flash[:notice] = 'You must be activated to access this page.'
      end
    end
  
end