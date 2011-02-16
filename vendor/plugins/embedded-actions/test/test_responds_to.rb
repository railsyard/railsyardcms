require File.expand_path(File.dirname(__FILE__) + "/rails/test/test_helper")

# Add 'lib' to ruby's library path and load the plugin libraries (code copied from Rails railties initializer's load_plugin)
#lib_path  = File.expand_path(File.dirname(__FILE__) + "/../lib")
#application_lib_index = $LOAD_PATH.index(File.join(RAILS_ROOT, "lib")) || 0  
#$LOAD_PATH.insert(application_lib_index + 1, lib_path)
#require File.expand_path(File.dirname(__FILE__) + "/../init")

# Re-raise errors caught by the controller.
class TestController; def rescue_action(e) raise e end; end

class RespondsToTest < ActionController::TestCase
  def setup
    @controller = TestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    FileUtils.rm_rf "#{RAILS_ROOT}/tmp/cache/test.host"
  end

  def test_responds_to_embedded
    get :action_with_respond_to
    assert_equal "html content", @response.body, "should respond with html content"
    assert_equal "text/html", @response.content_type

    get :action_that_calls_action_with_respond_to, :format => "text/html"
    assert_equal "embedded content", @response.body, "should respond with embedded content"
    assert_equal "text/html", @response.content_type
  end
  
  def test_mime_type_extensions
    get :mime_test_1
    assert_equal "MIME TEST 1 HTML\nMIME TEST 2 EMBEDDED\nMIME TEST 3 EMBEDDED", @response.body, "should have rendered 'mime_test_1.html'"
  end
end
