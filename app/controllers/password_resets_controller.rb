class PasswordResetsController < ApplicationController
  
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  layout 'full_width'
  
  def new
  end

  def create
    @user = params[:identifier] =~ /@/ ? User.find_by_email( params[:identifier] ) : User.find_by_screen_name( params[:identifier] )
    
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = 'Instructions to reset your password have been emailed to you. Please check your email.'
      redirect_to login_url
    else
      flash[:notice] = 'No user with that email address or screen name was found.'
      render :action => :new
    end
  end

  def edit
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      @user_session = UserSession.create(@user)
      flash[:notice] = 'Password successfully updated'
      redirect_to user_path(@user)
    else
      render :action => :edit
    end
  end

  private
  
    def load_user_using_perishable_token
      @user = User.find_using_perishable_token(params[:id])
      unless @user
        flash[:notice] = "We're sorry, but we could not locate your account. " +
          "If you are having issues try copying and pasting the URL " +
          "from your email into your browser or restarting the " +
          "reset password process."
        redirect_to new_password_reset_path
      end
    end
  
  
end
