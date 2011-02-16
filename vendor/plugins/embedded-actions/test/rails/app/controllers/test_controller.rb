class TestController < ActionController::Base
  cattr_accessor :test_value
  cattr_accessor :another_value

  caches_embedded :cached_action

  def cached_action
    @id = params[:id]
    @value = TestController.test_value || "N/A"
    
    render :template => "test/value", :layout => false
  end
  
  def regular_action
    @id = params[:id]
    @value = TestController.test_value || "N/A"
    
    render :template => "test/value", :layout => false
  end
  
  caches_embedded :cached_variable_action, :options_for_name => Proc.new { {:value => TestController.another_value}}
  def cached_variable_action
    @id = params[:id]
    @value = TestController.test_value || "N/A"
    
    render :template => "test/value", :layout => false
  end
  
  def embedded_actions
    render :template => "test/embedded_actions"
  end

  def embedded_overrides
    render :template => "test/embedded_overrides"
  end

  def embedded_variable_actions
    render :template => "test/embedded_variable_actions"
  end

  def forced_refresh
    render :template => "test/forced_refresh"
  end
  
  def dump_params
    render :inline => 'Params: <%= params.keys.sort.collect {|name| "#{name}: #{params[name]}"}.join ", " %>'
  end  

  def action_with_respond_to
    respond_to do |format|
      format.html     { render :inline => "html content"     }
      format.embedded { render :inline => "embedded content" }
      format.all      { render :inline => "catch all" }
    end
  end

  def action_that_calls_action_with_respond_to
    render :inline => "<%= embed_action :action => 'action_with_respond_to' %>"
  end

  def inline_erb_action
    render :inline => params[:erb]
  end
    
  def call_uncached_controller
     render :text => embed_action_as_string(:controller => "test_no_caching",:action => "cached_action")
  end  
  
  def call_namespaced_action
     render :text => embed_action_as_string(:controller => "admin/namespace_test", :action => 'cached_action')
  end
  
  def mime_test_1
    respond_to do |format|
      format.html     { render }
      format.embedded { render }
      format.all      { render :inline => "format not found" }
    end
  end

  def mime_test_2
    respond_to do |format|
      format.html     { render }
      format.embedded { render }
      format.all      { render :inline => "format not found" }
    end
  end

  def mime_test_3
    respond_to do |format|
      format.html     { render }
      format.embedded { render }
      format.all      { render :inline => "format not found" }
    end
  end
end

