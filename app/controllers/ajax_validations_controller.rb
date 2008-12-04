class AjaxValidationsController < ApplicationController
  
  def validate_email
    respond_to do |wants|
      wants.html {  }
      wants.js { render :text => @template.email_taken?(params[:email]), :layout => false }
    end
  end
  
  def validate_screen_name
    respond_to do |wants|
      wants.html { }
      wants.js { render :text => @template.screen_name_taken?(params[:name]), :layout => false }
    end
  end
  
end
