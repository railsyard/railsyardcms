require File.expand_path(File.dirname(__FILE__) + "/rails/test/test_helper")

# Add 'lib' to ruby's library path and load the plugin libraries (code copied from Rails railties initializer's load_plugin)
#lib_path  = File.expand_path(File.dirname(__FILE__) + "/../lib")
#application_lib_index = $LOAD_PATH.index(File.join(RAILS_ROOT, "lib")) || 0  
#$LOAD_PATH.insert(application_lib_index + 1, lib_path)
#require File.expand_path(File.dirname(__FILE__) + "/../init")

# Re-raise errors caught by the controller.
class TestController; def rescue_action(e) raise e end; end

class EmbeddedActionTest < ActionController::TestCase
  def setup
    @controller = TestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    FileUtils.rm_rf "#{RAILS_ROOT}/tmp/cache/test.host"
  end

  def test_embed_action
    get :inline_erb_action, :erb => "<%= embed_action :action => 'dump_params' %>"
    assert_equal "Params: action: dump_params, controller: test, id: ", @response.body, "embed_action should accept implicit controller"
    assert_equal "text/html", @response.content_type

    get :inline_erb_action, :erb => "<%= embed_action :controller => 'test', :action => 'dump_params' %>"
    assert_equal "Params: action: dump_params, controller: test, id: ", @response.body, "embed_action should accept explicit controller"
    assert_equal "text/html", @response.content_type
                     
    get :inline_erb_action, :erb => "<%= embed_action :action => 'dump_params', :id => 'the id' %>"
    assert_equal "Params: action: dump_params, controller: test, id: the id", @response.body, "embed_action should pass the id"
    assert_equal "text/html", @response.content_type
                     
    get :inline_erb_action, :erb => "<%= embed_action :action => 'dump_params', :id => 'the id', :params => {:color => 'blue'} %>"
    assert_equal "Params: action: dump_params, color: blue, controller: test, id: the id", @response.body, "embed_action should pass params as expected"
    assert_equal "text/html", @response.content_type
                     
    get :inline_erb_action, :erb => "<%= embed_action :action => 'dump_params', :id => 'the id', :color => 'blue' %>"
    assert_equal "Params: action: dump_params, color: blue, controller: test, id: the id", @response.body, "embed_action should merge into params anything that's not standard"
    assert_equal "text/html", @response.content_type
                     
    get :inline_erb_action, :erb => "<%= embed_action :action => 'dump_params', :id => 'the id', :color => 'blue', :params => {:color => 'red'} %>"
    assert_equal "Params: action: dump_params, color: red, controller: test, id: the id", @response.body, "embed_action should override with the contents of params"
    assert_equal "text/html", @response.content_type

    get :inline_erb_action, :erb => "<%= embed_action :action => 'dump_params', :id => 'the id', :color => 'blue', :params => {'color' => 'red'} %>"
    assert_equal "Params: action: dump_params, color: red, controller: test, id: the id", @response.body, "embed_action should allow indifferent access"
    assert_equal "text/html", @response.content_type
  end

end
