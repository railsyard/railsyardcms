require File.expand_path(File.dirname(__FILE__) + "/rails/test/test_helper")

# Add 'lib' to ruby's library path and load the plugin libraries (code copied from Rails railties initializer's load_plugin)
#lib_path  = File.expand_path(File.dirname(__FILE__) + "/../lib")
#application_lib_index = $LOAD_PATH.index(File.join(RAILS_ROOT, "lib")) || 0  
#$LOAD_PATH.insert(application_lib_index + 1, lib_path)
#require File.expand_path(File.dirname(__FILE__) + "/../init")

# Re-raise errors caught by the controller.
class TestController; def rescue_action(e) raise e end; end

class CachesEmbeddedTest < ActionController::TestCase
  def setup
    @controller = TestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    FileUtils.rm_rf "#{RAILS_ROOT}/tmp/cache/views/test.host"
  end

  def test_embedded_caching
    TestController.test_value = 1
    get :embedded_actions
    assert_equal "regular value is 1\ncached value is 1", @response.body

    TestController.test_value = 2
    get :embedded_actions
    assert_equal "regular value is 2\ncached value is 1", @response.body
    
    @controller.expire_embedded :controller => "test", :action => "cached_action"
    get :embedded_actions
    assert_equal "regular value is 2\ncached value is 2", @response.body
  end
  
  def test_should_not_return_from_cache_if_params_are_different
    TestController.test_value = "test"
    get :cached_action, :id => 2
    assert_equal "test (id=2)", @response.body
    
    get :cached_action, :id => 3
    assert_equal "test (id=3)", @response.body
  end

  def test_ensure_caching_only_is_enabled_where_it_should_be
    TestNoCachingController.test_value = 1
    get :call_uncached_controller
    assert_equal "This should never cache. value: 1", @response.body
    
    TestNoCachingController.test_value = 2
    get :call_uncached_controller
    assert_equal "This should never cache. value: 2", @response.body
  end

  def test_should_cache_properly_with_namespaced_controllers
    Admin::NamespaceTestController.test_value = 1
    get :call_namespaced_action
    assert_equal "Namespace cache test. value: 1", @response.body
    
    Admin::NamespaceTestController.test_value = 2
    get :call_namespaced_action
    assert_equal "Namespace cache test. value: 1", @response.body
    
    @controller.expire_embedded :controller => "admin/namespace_test", :action => "cached_action"
    get :call_namespaced_action
    assert_equal "Namespace cache test. value: 2", @response.body
  end

  def test_embedded_caching_overrides
    # This page uses explicit overrides to reverse which embedded actions are cached
    
    TestController.test_value = 1
    get :embedded_overrides
    assert_equal "regular value is 1\ncached value is 1", @response.body, 'First call should not have been cached'

    TestController.test_value = 2
    get :embedded_overrides
    assert_equal "regular value is 1\ncached value is 2", @response.body, "Second call should reflect cached value"
    
    @controller.expire_embedded :controller => "test", :action => "regular_action"
    get :embedded_overrides
    assert_equal "regular value is 2\ncached value is 2", @response.body, "Expiration should have forced a refreshed value"
  end

  def test_embedded_caching_refresh
    # This page uses explicit overrides to force refreshing the cache
    
    TestController.test_value = 1
    get :forced_refresh
    assert_equal "regular value is 1\ncached value is 1", @response.body, "First call should not have been cached"

    TestController.test_value = 2
    get :forced_refresh
    assert_equal "regular value is 2\ncached value is 1", @response.body, "Second call should reflect the cached value"
    
    get :forced_refresh, :refresh => true
    assert_equal "regular value is 2\ncached value is 2", @response.body, "Call with refresh should reflect the new valu"

    TestController.test_value = 3
    get :forced_refresh
    assert_equal "regular value is 3\ncached value is 2", @response.body, "Another call without refresh should reflect the cached value"
  end

  def test_caches_embedded_across_inheritance_tree
    @controller = InheritingController.new

    InheritingController.test_value = "foo"
    get :inline_erb_action, :erb => "<%= embed_action :action => 'cached_action' %>"
    assert_equal "foo", @response.body

    InheritingController.test_value = "bar"
    get :inline_erb_action, :erb => "<%= embed_action :action => 'cached_action' %>"
    assert_equal "foo", @response.body

    InheritingController.test_value = "bar"
    @controller.expire_embedded :controller => "inheriting", :action => "cached_action"
    get :inline_erb_action, :erb => "<%= embed_action :action => 'cached_action' %>"
    assert_equal "bar", @response.body
  end

  def test_caches_embedded_with_custom_options_for_cache_name
    TestController.another_value = 1

    TestController.test_value = 1
    get :embedded_variable_actions
    assert_equal "regular value is 1\ncached value is 1", @response.body, 'First call should not have been cached'

    TestController.test_value = 2
    get :embedded_variable_actions
    assert_equal "regular value is 2\ncached value is 1", @response.body, "Second call should reflect cached value"

    TestController.another_value = 2
    get :embedded_variable_actions
    assert_equal "regular value is 2\ncached value is 2", @response.body, "Third call should reflect updated value since variable in cache name changed"
  end
end

