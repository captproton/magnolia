module AjaxValidationsHelper
  
  def email_taken?(email)
    if email !~ /^([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})$/
      return "<img src=\"/images/icons/yellow_reject.gif\" class=\"status_icon\"/> Please enter a valid email address."
    elsif User.find_by_email(email)
      return "<img src=\"/images/icons/yellow_reject.gif\" class=\"status_icon\"/> This email is in use."
    else
      return "<img src=\"/images/icons/green_accept.gif\" class=\"status_icon\"/> This email is not in use."
    end
  end

  def screen_name_taken?(name)
    if name !~ /^[\w\._\-\d]+$/
      return "<img src=\"/images/icons/yellow_reject.gif\" class=\"status_icon\"/> Your screen name can only contain letters, numbers, dots, underscores, and dashes."
    elsif User.find_by_screen_name(name)
      return "<img src=\"/images/icons/yellow_reject.gif\" class=\"status_icon\"/> This screen name is taken."
    else
      return "<img src=\"/images/icons/green_accept.gif\" class=\"status_icon\"/> This screen name is available."
    end
  end
  
end
