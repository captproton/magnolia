class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    user.reset_perishable_token!  
    UserNotifier.deliver_signup_notice(user)
  end

end