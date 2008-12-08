module OpenIdUtils
  
  include Acts::Eaut
  acts_as_eaut
  
  private

    # Override this method to provide behaviour for the non-OpenId authentication process.
    def non_open_id_create
      throw "Implement me in this controller!"
    end
        
    # Delegates the OpenId authentication process to the open_id_authentication plugin and 
    # handles the results by delegating to #successful_openid_login or #failed_openid_authentication.
    # 
    # A base implementation is provided for #failed_openid_authentication but #successful_openid_login
    # will throw an error if it is not implemented in the including controller.
    def open_id_authentication( options = {})
    
      authenticate_with_open_id( params[:openid_identifier], 
          options.update( :required => [ :email ], 
          :optional => [ :nickname ] )
        ) do |result, identity_url, registration|
            
        if result.successful?
          successful_openid_authentication identity_url, registration 
        else
          failed_openid_authentication result.message
        end
      end
      
      # return true # is this necessary?
    end

    # Override this method to provide behaviour for a successful OpenId authentication.
    def successful_openid_authentication( identity_url, registration = {} )
      throw "Implement me in this controller!"
    end
 
    def failed_openid_authentication( message )
      flash.now[:error] = message
      render :action => 'new'
    end
    
    # Returns true if the identity_url field is not an email or if params[:open_id_complete] is present.
    #
    # overrides OpenIdAuthentication#using_open_id?
    def using_open_id?(identity_url = nil) #:doc:
      return true if params[:open_id_complete]
      identity_url ||= params[:openid_identifier] || params[:openid_url]
      identity_url.blank? ? false : !identity_field_is_email?(identity_url)
    end
    
    # Returns true if params[:openid_url] contains an email address
    #
    # For our purposes and email address is any value that contains an '@' character that is not the 
    # first character of the string since an openid cannot contain an '@' character unless it is an iname being
    # used as an openid, in which case the '@' must be the first character.
    def identity_field_is_email?(identity_url)
      identity_url.include?('@') && (identity_url =~ /^[@]/).nil?
    end
end
