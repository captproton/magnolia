module AuthenticationSpecHelper
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  def mock_user_session(stubs={})
    @mock_user_session ||= mock_model(UserSession, stubs)
  end

  def login_as(user)
    UserSession.should_receive(:find).and_return(mock_user_session)
    mock_user_session.should_receive(:record).and_return(user)
  end
  
end
