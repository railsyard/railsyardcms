module ActionController
  module DefaultEmbeddedOptions

    def self.included(base) # :nodoc:
      base.send :include, InstanceMethods
      base.extend(ClassMethods)

      base.class_eval do
        alias_method_chain :embed_action_as_string, :default_options
      end
    end

    module ClassMethods
    end
  
    module InstanceMethods
      def normalize_embedded_options(options)
        return {} if options.nil?
        
        for key in options.keys
          unless [:controller, :action, :id, :params].include? key.to_sym
            options[:params] ||= {}
            value = options.delete(key)
            options[:params][key.to_sym] = value unless options[:params][key.to_sym]
          end
        end
        options
      end
      
      # By default, use any default_url_options defined by the application controller
      # This method can be overwritten to provide different defaults for embedded actions
      def default_embedded_options(options)
        normalize_embedded_options(default_url_options(options))
      end

      def rewrite_embedded_options(options) #:nodoc:
        options = normalize_embedded_options(options)
        
        if defaults = default_embedded_options(options)
          options[:params] = defaults[:params].merge(options[:params] || {}) if defaults[:params]
          options = defaults.merge(options)
        end
        options
      end
      
      def embed_action_as_string_with_default_options(options)
        embed_action_as_string_without_default_options(rewrite_embedded_options(options))
      end
    end
  end
end
