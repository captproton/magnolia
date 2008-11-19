class UserSessionsController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  layout 'full_width'
  
  # Displays the login form.
  # Mapped to route /login
  def new
    @section = 'authentication'
    @user_session = UserSession.new
  end

  # Logs the user in.
  def create
    
    respond_to do |wants|

      # The un/pw based form submits a regular html request
      wants.html do
        
        # if params[:user_session][:password]
          # do regular login
          
        @user_session = UserSession.new(params[:user_session])
        if @user_session.save
          flash[:notice] = 'Login successful!'
          redirect_back_or_default root_url
        else
          @show_password_form = true
          render :action => :new
        end
      end
      
      # The openid/email form uses Ajax
      wants.js do 
        # is the identity field an email or an OpenId
        # if openId do openId
        # if email
          # try EAUT
          # try directed id on the domain portion
          # else display the password based login form
        @section = 'authentication'
        @user_session = UserSession.new
        render :update do |page|
          page['authentication_form_container'].replace :partial => 'password_form'
          # page.redirect_to root_url
        end
      end
    end
  end

  # Logs the user out.
  # Mapped to route /logout
  def destroy
    @user_session.destroy
    flash[:notice] = 'Logout successful!'
    redirect_to login_url
  end
  
  private
  
    # Exposes the data needed to render the AuthenticationProvider select box and the users remembered selection.
    def set_auth_providers
      # @preferred_auth_provider = cookies[:Magnolia_Auth_Method] ? Struct::AuthProvider.new( cookies[:Magnolia_Auth_Method] ) : Struct::AuthProvider.new( 'openid' )
      # @windows_app_id = ENV['WINDOWS_LIVE_ID']
    end
  
end
