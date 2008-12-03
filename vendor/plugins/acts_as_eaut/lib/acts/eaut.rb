# Utilities for transforming an email address into an OpenID following the
# Email-to-OpenID translation specification.
require 'uri' 
require 'net/http'
require 'openid'
require 'ruby-debug'

module Acts
  module Eaut

    TEMPLATE_TYPE = 'http://specs.eaut.org/1.0/template'
    MAPPER_TYPE = 'http://specs.eaut.org/1.0/mapping'
    FALLBACK_SERVICE = 'http://emailtoid.net/'
    
    VALID_TYPES = [TEMPLATE_TYPE, MAPPER_TYPE]
    
    class NoValidEndpoints < StandardError; end
    class OpenIDTranslationError < StandardError; end
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def acts_as_eaut()
        include Acts::Eaut::InstanceMethods
      end

    end
 
    module InstanceMethods
      # Transform an email address into an OpenID.
      # 
      # Accept a well-formed email address and return a string of the resulting OpenID.
      # 
      # If an XRDS document is not found from the email address's domain, or if
      # there is no eaut type, use the fallback service of http://emailtoid.net.
      # 
      # JC: The site_name parameter is not mentioned in the spec so I am not using it
      # even though it is in the python lib....      
      def get_openid_for_email( email_address, options = {} )
        
        { :use_fallback_service => true }.merge( options )
        
        email_username, email_domain = email_address.split('@')
        
        begin
          eaut_endpoint = get_eaut_endpoint("http://#{email_domain}")
        rescue OpenID::DiscoveryFailure, NoValidEndpoints
          if options[:use_fallback_service]
            eaut_endpoint = get_eaut_endpoint(FALLBACK_SERVICE)
          else
            raise( NoValidEndpoints, "No valid EAUT endpoints found at http://#{email_domain} and fallback service not in use.")
          end
        end
        
        case eaut_endpoint.match_types(VALID_TYPES).first 
        when TEMPLATE_TYPE
          eaut_endpoint.uri.sub('%7Busername%7D', email_username)
        when MAPPER_TYPE
          uri = URI.parse(eaut_endpoint.uri) 
          append_char = uri.query ? '&' : '?'
          mapper_url = build_mapper_url(eaut_endpoint, email_address, append_char)
          mapper_uri = URI.parse( mapper_url )
          response = Net::HTTP.start(mapper_uri.host) { |http|
            http.get(mapper_uri.path + '?' + mapper_uri.query)
          }
          raise( OpenIDTranslationError, 'Invalid response from EAUT mapping service.' ) if response.code != '302'
          return response['location']
        end

      end
       
      # Attempts to discover an XRDS document for a given url and return any valid 
      # email transformation endpoints. If non endpoints are found, raises a NoValidEndpoints exception.
      def get_eaut_endpoint(url)
        endpoints = OpenID::Yadis.get_service_endpoints(url).flatten.select do |e| 
           e.respond_to?('match_types') && !e.match_types( VALID_TYPES ).empty? ? true : false
        end
        raise( NoValidEndpoints, "No valid EAUT endpoints found at #{url}") if endpoints.empty?
        endpoints.first
      end
      
      def build_mapper_url(eaut_endpoint, email_address, append_char)
        eaut_endpoint.uri + "#{append_char}email=#{email_address}"
      end
      
    end
  end
end
