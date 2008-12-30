module BeforeFilterSpecHelper
  
  # Returns an Array containing the actions for the current controller to which the given filter has been applied
  def get_actions_to_test(filter_method)
    
    current_filter = controller.class.filter_chain.detect do |f| 
      f.kind_of?( ActionController::Filters::BeforeFilter ) && f.method == filter_method 
    end
      
    return [] unless current_filter
    
    if current_filter.options[:only]
      current_filter.options[:only]
    elsif current_filter.options[:except]
      current_filter.options[:except]
    else
      controller.class.public_instance_methods(false).reject{ |action| ['rescue_action'].include?(action) }
    end
  end
  
  # This method does the bulk of the work for testing before filters. For a given filter_method, 
  # it gets a collection of actions that the filter has been applied to setups expectations for the action
  # then iterates over them calling get, post, put, or delete with the appropriate parameters 
  # to execute the action.
  def test_before_filter( filter_method )
    
    actions_to_test = get_actions_to_test(filter_method)
    
    return if actions_to_test.empty?
    
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
      
      if ['show', 'edit', 'update', 'destroy'].include?( action )      
        self.send(method, action, :id => 1)
      else
        self.send(method, action)
      end
      
      self.send( "#{filter_method.to_s}_post_send_requirements" )      
    end
  end
  
  # ================
  # = Expectations =
  # ================

  # The #{filter_name}_pre_send_requirements and #{filter_name}_post_send_requirements are where the expectations
  # specific to each before_filter are setup. The pre_send method is called only once before we start iterating over and 
  # calling the actions. The post_send method is called once for each action immediately after we call get, post, put, or delete
  # for that action
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
end