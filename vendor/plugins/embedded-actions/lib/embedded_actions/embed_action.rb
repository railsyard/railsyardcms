module ActionController  #:nodoc:
  # Embedded Actions are just like regular actions, but they are referenced from
  # inside other actions, or rather, inside other views.
  # They are similar to a partial, but preceded by the execution of an action.

  module EmbeddedActions
    def self.included(base) # :nodoc:
      base.send :include, InstanceMethods
      base.extend(ClassMethods)

      base.helper do
        def embed_action(options)
          @controller.send(:embed_action_as_string, options)
        end
      end

      # If this controller was instantiated to process an embedded request,
      # +parent_controller+ points to the instantiator of this controller.
      base.send :attr_accessor, :parent_controller

      base.class_eval do
        alias_method_chain :send_response,        :embedded
        alias_method_chain :process_cleanup,      :embedded
        alias_method_chain :set_session_options,  :embedded if base.methods.singleton_methods.include? "set_session_options"
        alias_method_chain :flash,                :embedded

        alias_method :embedded_request?, :parent_controller
      end
    end

    module ClassMethods
      # Track parent controller to identify embedded requests
      def process_with_embedded(request, response, parent_controller = nil) #:nodoc:
        controller = new
        controller.parent_controller = parent_controller
        controller.process(request, response)
      end
    end

    module InstanceMethods
      # Extracts the action_name from the request parameters and performs that action.
      def process_with_embedded(request, response, method = :perform_action, *arguments) #:nodoc:
        flash.discard if embedded_request?
        process_without_embedded(request, response, method, *arguments)
      end

      def send_response_with_embedded
        if embedded_request?
          response.content_type = nil
        else
          response.prepare! 
        end
        response
      end

      protected
        def cleanup_options_for_embedded(options)
          options = options.with_indifferent_access
          controller = options.delete(:controller)
          action = options.delete(:action)
          id = options.delete(:id)
          params = options.delete(:params) || {}
          clean_options = {}
          clean_options[:controller] = controller.to_s if controller
          clean_options[:action] = action.to_s if action
          clean_options[:id] = id if id
          clean_options[:params] = options.merge(params) # Merge any remaining key into params
          clean_options.delete(:params) if clean_options[:params].size == 0
          clean_options
        end
        
        # Renders the embedded action specified as the response for the current method
        def embed_action(options) #:doc:
          embedded_logging(options) do
            response = embedded_response(options, true)
            render_for_text(response.body, response.headers["Status"])
          end
        end

        # Returns the embedded action response as a string
        def embed_action_as_string(options) #:doc:
          embedded_logging(options) do
            response_for_embeded_action = embedded_response(options, false)

            if redirected = response_for_embeded_action.redirected_to
              embed_action_as_string(redirected)
            else
              response_for_embeded_action.body
            end
          end
        end

        def flash_with_embedded(refresh = false) #:nodoc:
          if refresh || flash_without_embedded.nil?
            @_flash = parent_controller.flash if parent_controller
          end

          flash_without_embedded
        end

      private
        def embedded_response(options, reuse_response)
          options = cleanup_options_for_embedded(options)

          klass    = embedded_class(options)
          request  = request_for_embedded(klass.controller_name, options)
          if reuse_response
            new_response = response
          else
            if ActionController.const_defined? "Response"
              new_response = ActionController::Response.new
              ActionController::Response::DEFAULT_HEADERS.each {|k, v| new_response.headers[k] = v}
            else
              new_response = response.dup
              new_response.headers.clear
              response.class::DEFAULT_HEADERS.each { |k, v| new_response.headers[k] = v }
            end
            
            # Using a content-encoding header prevents output compression filters from messing with this response
            new_response.headers['Content-Encoding'] = "identity"
          end
          
          klass.process_with_embedded(request, new_response, self)
        end

        # determine the controller class for the embedded action request
        def embedded_class(options)
          if controller = options[:controller]
            controller.is_a?(Class) ? controller : "#{controller.camelize}Controller".constantize
          else
            self.class
          end
        end

        # Create a new request object based on the current request.
        # The new request inherits the session from the current request,
        # bypassing any session options set for the embedded action controller's class
        def request_for_embedded(controller_name, options)
          request         = self.request.dup
          request.session = self.request.session

          request.instance_variable_set(
            :@parameters,
            (options[:params] || {}).with_indifferent_access.update(
              "controller" => controller_name, "action" => options[:action], "id" => options[:id]
            )
          )
          
          request.instance_variable_set(:@accepts, [Mime::EMBEDDED])
          request.instance_variable_set(:@_memoized_accepts, [Mime::EMBEDDED])
          request.instance_variable_set(:@format, Mime::EMBEDDED)

          request
        end

        def embedded_logging(options)
          if logger
            logger.info "Start rendering embedded action (#{options.inspect}): "
            result = yield
            logger.info "\n\nEnd of embedded action rendering"
            result
          else
            yield
          end
        end

        def set_session_options_with_embedded(request)
          set_session_options_without_embedded(request) unless embedded_request?
        end

        def process_cleanup_with_embedded
          process_cleanup_without_embedded unless embedded_request?
        end
    end
  end

  # Psst... psst... the emperor has no clothes
end
