class UserSessionsController < ApplicationController

  include OpenIdUtils
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  layout 'full_width'
  
  # Displays the login form.
  # Mapped to route /login
  def new
    @section = 'authentication'
    @user_session = UserSession.new
  end

  # Logs the user out.
  # Mapped to route /logout
  def destroy
    @user_session.destroy
    flash[:notice] = 'Logout successful!'
    redirect_to login_url
  end
  
  private
    
    def email_authentication
      user = User.find_by_email( params[:openid_identifier] ) ? authenticate_existing_user( user ) : authenticate_new_user
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
      redirect_back_or_default home_url
      
    else
      failed_openid_authentication('We were unable to authenticate you with this OpenId.')
    end
  end
    
    
end
