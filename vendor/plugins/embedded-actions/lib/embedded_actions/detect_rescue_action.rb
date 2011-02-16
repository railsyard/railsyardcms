module ActionController::Rescue
  # If an exception is raised when processing an action, we want to know it
  # down the road.
  # Since some rendering methods (render_embeded, render :partial, etc) don't have access
  # to the original request, the best place to "store" the exception information
  # is in the response body.
  protected
  def rescue_action_with_exception_detection(exception)
    rescue_action_without_exception_detection(exception)
    
    body = response.body
    class <<body
      attr_accessor :exception_rescued
    end
    body.exception_rescued = exception
  end

  alias_method :rescue_action_without_exception_detection, :rescue_action
  alias_method :rescue_action, :rescue_action_with_exception_detection
end
  