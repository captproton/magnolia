class PagesController < ApplicationController

  layout 'full_width'
  
  def show
    @user = @current_user
    render :template => "pages/#{params[:page]}"
  end
  
end
