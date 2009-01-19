module Facebooker
  module Rails
    module Helpers
      module FbConnect
        
        def fb_connect_javascript_tag
          javascript_include_tag "http://static.ak.connect.facebook.com/js/api_lib/v0.4/FeatureLoader.js.php"
        end
        
        # See: http://wiki.developers.facebook.com/index.php/JS_API_M_FB.Facebook.Init_2
        # See: http://wiki.developers.facebook.com/index.php/JS_API_M_FB.Bootstrap.requireFeatures
        # - required_features: an array of strings for the Facebook Features to be loaded by the FB JS API
        # - app_settings: Needs to be a string containing a json hash. 
        # We can't use to_json for the app_settings because that would prevent passing in callback method references...
        def init_fb_connect(required_features = ['Api'], app_settings = '{}')
          init_string = "FB.Facebook.init('#{Facebooker.api_key}', '/xd_receiver.html', #{app_settings});"
          unless required_features.blank?
             init_string = <<-FBML
              Element.observe(window, 'load', function() {
                FB_RequireFeatures(#{required_features.to_json}, function() {
                  #{init_string}
                });
              });
              FBML
          end
          javascript_tag init_string
        end
        
        def fb_login_button(callback=nil)
          content_tag("fb:login-button",nil,(callback.nil? ? {} : {:onlogin=>callback}))
        end
        
        def fb_unconnected_friends_count
          content_tag "fb:unconnected-friends-count",nil
        end
      end
    end
  end
end