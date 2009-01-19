class UserSessionsController < ApplicationController

  include OpenIdUtils
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  layout 'full_width'
  helper_method :open_id_redirect_url
  
  # Displays the login form.
  # Mapped to route /login
  def new
    @section = 'authentication'
    @user_session = UserSession.new
  end

  # Logs the user out.
  # Mapped to route /logout
  def destroy
    @user_session.destroy if @user_session
    
    # handle facebook cookies
    cookies.keys.each do |key|
      if key =~ Regexp.new( Facebooker.api_key )
        cookies.delete key
      end
    end
    
    flash[:notice] = 'Logout successful!'
    redirect_to login_url
  end
  
  # The entry point action for UserSession creation.
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
      open_id_authentication :using_ajax => true
      
    else # the field entered is an email 
      if user = User.find_by_email( params[:openid_identifier] )
        authenticate_existing_user( user ) 
      else
        authenticate_new_user
      end

    end
  end
  
  private
    
    # Starts OpenId authentication if there is an open_id associated with the given user. 
    # Otherwise starts the non-OpenId process.
    def authenticate_existing_user( user )
      
      if open_id = OpenId.find_by_user_id( user.id )
        params[:openid_identifier] = open_id.openid_identifier
        open_id_authentication :using_ajax => true
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
        open_id_authentication :using_ajax => true
      else
        non_open_id_create
      end
    end
    
    # Logs the user in.
    def non_open_id_create

      respond_to do |wants|
        
        # This condition will occur if the email/pw form is being submitted
        wants.html do
          
          @user_session = UserSession.new(params[:user_session])
          if @user_session.save
            flash[:notice] = 'Login successful!'
            redirect_back_or_default root_url
          else
            @show_password_form = true
            render :action => :new
          end
        end

        # If we get here it means a user entered an email address and we need to 
        # update the page to display the password form
        wants.js do 

          @user_session = UserSession.new(:email => params[:openid_url])
          render :update do |page|
            page['authentication_form_container'].replace :partial => 'password_form'
          end
        
        end
      end
    end
  
  # called from OpenIdsHelper#open_id_authentication on success
  def successful_openid_authentication(identity_url, registration = {})
    
    if user = User.find_by_open_id(identity_url)
      @user_session = UserSession.create(user)
      redirect_back_or_default root_url
      
    else
      failed_openid_authentication('We were unable to authenticate you with this OpenId.')
    end
  end
    
    
end
