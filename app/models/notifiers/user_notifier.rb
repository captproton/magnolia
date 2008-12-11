class UserNotifier < ActionMailer::Base

  def signup_notice(user)
    recipients user.email
    subject "Ma.gnolia Account Activation"
    from "support@ma.gnolia.com"
    body[:user] = user
  end
  
end
