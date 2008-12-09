class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    UserNotifier.deliver_signup_notification(user)
  end

end