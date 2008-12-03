module OpenIdUtils
  
  include Acts::Eaut
  acts_as_eaut
  
  # The entry point action for User and UserSession creation.
  # Applies business rules to determine if open_id_authentication should be used vs. the regular un/pw process.
  #
  # if the user entered an email
  #   if the email matches an account 
  #     with an associated openid, 
  #       do openid
  #     WITHOUT an associated openid, 
  #       do un/pw
  #   else no account
  #     if EAUT returns an openid 
  #       do openid
  #     else 
  #       do un/pw
  # else
  #   try openid with whatever the user provided
  def create
    
    if using_open_id?
      open_id_authentication
      
    else # the field entered is an email 
      email_authentication

    end # if using_open_id?
  end
  
  private
  
    # Override this method to provide behaviour for email authentication process.
    def email_authentication
      throw "Implement me in this controller!"
    end
  
    # Starts OpenId authentication if there is an open_id associated with the given user. 
    # Otherwise starts the non-OpenId process.
    def authenticate_existing_user( user )
      
      if open_id = OpenId.find_by_user_id( user.id )
        params[:openid_identifier] = open_id.openid_url
        open_id_authentication
      else          
        non_open_id_create
      end
      
    end
  
    # Starts OpenId authentication if the email entered in openid_identifier can be translated to 
    # an OpenId using EAUT.
    # Otherwise starts the non-OpenId process.
    def authenticate_new_user
    
      # try EAUT # TODO: Refactor acts_as_eaut to yield a result wrapping status and error messages
      begin
        eaut_id = get_openid_for_email( params[:openid_identifier], :use_fallback_service => false )
      rescue
      end
      
      if eaut_id
        params[:openid_identifier] = eaut_id
        open_id_authentication
      else
        non_open_id_create
      end
      
    end

    # Override this method to provide behaviour for the non-OpenId authentication process.
    def non_open_id_create
      throw "Implement me in this controller!"
    end
        
    # Delegates the OpenId authentication process to the open_id_authentication plugin and 
    # handles the results by delegating to #successful_openid_login or #failed_openid_authentication.
    # 
    # A base implementation is provided for #failed_openid_authentication but #successful_openid_login
    # will throw an error if it is not implemented in the including controller.
    def open_id_authentication
    
      authenticate_with_open_id( params[:openid_identifier], 
          :required => [ :email ], 
          :optional => [ :nickname, :fullname ] 
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
      identity_url ||= params[:openid_identifier] || params[:openid_url]
      identity_url.blank? ? false : !identity_field_is_email?(identity_url) || params[:open_id_complete]
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
