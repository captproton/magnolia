module AuthenticationSpecHelper
  
  def valid_user_attributes( attributes = {} )
    {
      :email => 'value@email.com',
      :screen_name => "screen_name",
      :first_name => 'first_name',
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
      :accepted_terms_of_use => true,
      :active => false,
      :perishable_token => 'p_token'
    }.merge( attributes )
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
  
  # get all actions for a given controller
  def get_actions_to_test(controller, filter_method)
    current_filter = controller.class.filter_chain.detect { |f| f.method == filter_method }
    if current_filter.options[:only]
      actions_to_test = current_filter.options[:only]
    elsif current_filter.options[:except]
      actions_to_test = current_filter.options[:except]
    else
      actions_to_test = controller.public_instance_methods(false).reject{ |action| ['rescue_action'].include?(action) }
    end
  end
    
  def require_user_pre_send_requirements      
    controller.should_receive(:store_location).at_least(:once)
  end
  
  def require_user_post_send_requirements      
    response.should_not be_success
    response.should redirect_to( login_url )
    flash[:notice].should == BeforeFilterRequirements::LOGGED_IN_ERROR_MESSAGE
  end
    
  def require_no_user_pre_send_requirements     
    controller.should_receive(:store_location).at_least(:once)
  end

  def require_no_user_post_send_requirements      
    response.should_not be_success
    response.should redirect_to( user_path( assigns[:current_user] ) )
    flash[:notice].should == BeforeFilterRequirements::LOGGED_OUT_ERROR_MESSAGE
  end
    
  def require_active_user_pre_send_requirements     
  end

  def require_active_user_post_send_requirements      
    response.should_not be_success
    response.should redirect_to( user_activation_path( assigns[:current_user] ) )
  end
    
  def test_before_filter( filter_method )
    
    actions_to_test = get_actions_to_test( controller, filter_method )
      
    # setting pre send expectations within the iteration over actions caused multiple
    # expectations to be created and all but the first would fail
    self.send( "#{filter_method.to_s}_pre_send_requirements" )
      
    actions_to_test.each do |action|
      route = nil
      controller_short_name = controller.class.to_s.gsub('Controller', '').tableize
      
      ActionController::Routing::Routes.routes.each do |r| 
        route = r if r.requirements[:controller] == controller_short_name && r.requirements[:action] == action
      end
      
      method = route.conditions[:method]
      
      if ['show', 'edit', 'update', 'delete'].include?( action )      
        self.send(method, action, :id => 1)
      else
        self.send(method, action)
      end
      
      self.send( "#{filter_method.to_s}_post_send_requirements" )      
      
    end
  end
end
