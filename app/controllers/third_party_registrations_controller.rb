class ThirdPartyRegistrationsController < ApplicationController
  
  layout 'full_width'
  
  before_filter :require_no_user
  
  # GET /third_party_registration/new
  # Displays the third party registration form. That view will then post to the correct controller for the 
  # specific kind of registration method selected.
  def new
    @openid_identifier = params[:openid_identifier]
  end
  
  # This action displays the complete registration form.
  def edit
    @user = User.new params[:user]
  end
  
  def update

    redirect_to( :action => 'new' ) and return unless ( session[:openid_identifier] || ( facebook_session && facebook_session.user ) )

    @user = User.new params[:user]
    
    @user.open_ids << OpenId.new( :openid_identifier => session[:openid_identifier] ) if session[:openid_identifier]
    @user.facebook_identity = FacebookIdentity.new( :facebook_id => facebook_session.user.id ) if ( facebook_session && facebook_session.user )
    
    respond_to do |format|
      if @user.save
        session[:openid_identifier] = nil
        @user_session = UserSession.create(@user)
        @current_user = @user_session && @user_session.record
        format.html do
          render :template => 'user_activations/new'
        end
      else
        format.html { render :action => :edit }
      end
    end
  end
end
