class TestNoCachingController < ActionController::Base
  cattr_accessor :test_value
  # Same action name as an action which is cached in a different controller.
  def cached_action
    render :text => "This should never cache. value: #{test_value}"
  end
end

