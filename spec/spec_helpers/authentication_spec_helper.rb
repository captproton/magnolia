module AuthenticationSpecHelper
  
  def valid_user_attributes
    {
      :email => 'value@email.com',
      :screen_name => "screen_name",
      :password => 'value for password',
      :password_confirmation => 'value for password',
      :crypted_password => "value for crypted_password",
      :password_salt => "value for password_salt",
      :remember_token => "value for remember_token",
      :login_count => "1",
      :last_request_at => Time.now,
      :last_login_at => Time.now,
      :current_login_at => Time.now,
      :last_login_ip => "value for last_login_ip",
      :current_login_ip => "value for current_login_ip",
      :accepted_terms_of_use => true
    }
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  def mock_user_session(stubs={})
    @mock_user_session ||= mock_model(UserSession, stubs)
  end

  def login_as(user)
    UserSession.stub!(:find).and_return(mock_user_session)
    mock_user_session.stub!(:record).and_return(user)
  end
  
end
