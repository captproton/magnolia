module OpenIdUtils
  
  def using_facebook?
    return true if params[:facebook]
    false
  end
  
end