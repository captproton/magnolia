module ActionRequirements
  
  private
  
    def require_user
      unless @current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if @current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to @current_user
        return false
      end
    end
  
  
end