class UserNotifier < ActionMailer::Base

  def signup_notice(user)
    recipients user.email
    subject "Ma.gnolia Account Activation"
    from "support@ma.gnolia.com"
    body[:user] = user
  end
  
  def password_reset_instructions(user)
    recipients user.email
    subject "Ma.gnolia Password Reset Instructions"
    from "support@ma.gnolia.com"
    body[:user] = user
  end

end
