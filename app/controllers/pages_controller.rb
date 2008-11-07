class PagesController < ApplicationController

  layout 'basic'

  def index
    @user = @current_user
  end
end
