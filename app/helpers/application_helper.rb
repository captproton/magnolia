# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Show error and notice messages
  def show_system_messages
    if flash[:error]
      return content_tag("p", flash[:error], :class => "error")
    elsif flash[:notice]
      return content_tag("p", flash[:notice], :class => "flash notice")
    end
  end
  
  def disable_submit
    "this.down('.text_submit').addClassName('disabled');"
  end
  
end
