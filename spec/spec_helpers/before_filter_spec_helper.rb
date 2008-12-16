module BeforeFilterSpecHelper
  
  # Returns the actions for the given controller to which the given filter has been applied
  def get_actions_to_test(controller, filter_method)
    
    current_filter = controller.class.filter_chain.detect do |f| 
      f.kind_of?( ActionController::Filters::BeforeFilter ) && f.method == filter_method 
    end
    
    if current_filter.options[:only]
      current_filter.options[:only]
    elsif current_filter.options[:except]
      current_filter.options[:except]
    else
      controller.public_instance_methods(false).reject{ |action| ['rescue_action'].include?(action) }
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
    self.send( "#{filter_method.to_s}_pre_send_requirements" ) unless actions_to_test.empty?
      
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