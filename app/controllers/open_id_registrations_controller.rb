class OpenIdRegistrationsController < ApplicationController

  include OpenIdUtils
  
  layout 'full_width'
  
  before_filter :require_no_user
  
  # The entry point action for User creation.
  # Applies business rules to determine if open_id_authentication should be used vs. the regular un/pw process.
  #
  # if the user entered an email
  #   if the email matches an account 
  #     error - user already exists
  #   else no account
  #     if EAUT returns an openid 
  #       do openid
  #     else 
  #       do un/pw
  # else
  #   try openid with whatever the user provided
  def create
    
    if using_open_id?
      open_id_authentication( :required => [ :email ], :optional => [ :nickname ] )
      
    else # the field entered is an email 
      
      if user = User.find_by_email( params[:openid_identifier] )
        flash[:error] = 'An account with this email already exists.'
        @openid_identifier = params[:openid_identifier]
        render :action => :new
      
      else  
        # try EAUT # TODO: Refactor acts_as_eaut to yield a result wrapping status and error messages
        begin
          eaut_id = get_openid_for_email( params[:openid_identifier], :use_fallback_service => false )
        rescue
        end

        if eaut_id
          params[:openid_identifier] = eaut_id
          open_id_authentication( :required => [ :email ], :optional => [ :nickname ] )
        
        else
          # TODO check what they want to do here? display error page : redirect to un/pw
          redirect_to new_user_path # do un/pw signup
          
        end # if eaut_id
      end # if user exists
    end # if using_open_id?
  end
  
  private

    def successful_openid_authentication( openid_identifier, registration = {} )
      if user = User.find_by_open_id(openid_identifier)      
        flash[:error] = "This OpenID is already in use."
        render :action => 'new'
      else
        session[:openid_identifier] = openid_identifier
        redirect_to edit_third_party_registration_url :user => { :screen_name => registration['nickname'], :email => registration['email'] }
      end
    end

   def failed_openid_authentication( message )
     render :template => 'third_party_registrations/error'
   end

end
