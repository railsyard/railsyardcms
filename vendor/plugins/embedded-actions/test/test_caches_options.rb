require File.expand_path(File.dirname(__FILE__) + "/rails/test/test_helper")

# Add 'lib' to ruby's library path and load the plugin libraries (code copied from Rails railties initializer's load_plugin)
#lib_path  = File.expand_path(File.dirname(__FILE__) + "/../lib")
#application_lib_index = $LOAD_PATH.index(File.join(RAILS_ROOT, "lib")) || 0  
#$LOAD_PATH.insert(application_lib_index + 1, lib_path)
#require File.expand_path(File.dirname(__FILE__) + "/../init")

# Re-raise errors caught by the controller.

# Our arguments for the memory store are set per action as a hash
class TestController; 
  caches_embedded :cached_action, { :test_value => 5.minutes } 
  def rescue_action(e) raise e end; 
end

# We're hijacking write to verify that the options has is being passed
class MyOwnStore < ActiveSupport::Cache::MemoryStore
  def write(name, value, options=nil)
    TestController.test_value = options.is_a?(Hash) ? options[:test_value] : nil
    super
  end
end

class CachesOptionsTest < ActionController::TestCase
  def setup
    @controller = TestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    TestController.cache_store = MyOwnStore.new
  end

  def test_embedded_caching
    get :embedded_actions
    assert_equal 300, TestController.test_value 
  end
end

