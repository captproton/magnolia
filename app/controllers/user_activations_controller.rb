class UserActivationsController < ApplicationController
  
  before_filter :require_user
  
  layout 'full_width'
    
  def new
    @current_user.reset_perishable_token!  
    UserNotifier.deliver_signup_notice(@current_user)
  end

  # Overloaded the edit action to call update because we can only use GET links in emails
  def edit
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
