class UserNotifier < ActionMailer::Base

  def signup_notice(user)
    recipients user.email
    subject "Ma.gnolia Account Activation"
    from "support@ma.gnolia.com"
    body[:user] = user
    body[:url] = edit_user_activation_url( user.perishable_token )
  end
  
end
