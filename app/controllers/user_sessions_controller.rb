class UserSessionsController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  layout 'full_width'
  
  # Displays the login form.
  # Mapped to route /signin
  def new
    @section = 'authentication'
    @user_session = UserSession.new
    set_auth_providers
  end

  # Logs the user in.
  # Mapped to route /login
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = 'Login successful!'
      redirect_back_or_default root_url
    else
      render :action => :new
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
      @auth_providers = AuthenticationProvider.active
      
      # This is used to select the users preferred auth provider if present in cookies.
      Struct.new( 'AuthProvider', :name ) unless Struct.const_defined?( 'AuthProvider' )
      @preferred_auth_provider = cookies[:Magnolia_Auth_Method] ? Struct::AuthProvider.new( cookies[:Magnolia_Auth_Method] ) : Struct::AuthProvider.new( 'openid' )
      # @windows_app_id = ENV['WINDOWS_LIVE_ID']
    end
  
end
