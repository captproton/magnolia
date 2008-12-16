class UserActivationsController < ApplicationController
  
  before_filter :require_user
  
  layout 'full_width'
    
  def new
    @current_user.reset_perishable_token!  
    UserNotifier.deliver_signup_notice(@current_user)
  end

  # The edit form for UserActivations contains buttons to allow the user to resend the
  # activation notice email or start the registration process over.
  def edit
    flash[:notice] = 'You still need to activate your account.'
    render :action => :new
  end
  
  # Overloaded the show action to call update because we can only use GET links in emails
  def show
    update
  end
  
  def update
    if params[:id] == @current_user.perishable_token
      @current_user.update_attribute :active, true
      @current_user.reset_perishable_token!
      render :action => 'update'
    else      
      render :template => 'user_activations/error'
    end
  end

end
