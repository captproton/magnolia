class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    UserNotifier.deliver_signup_notice(user)
  end

end