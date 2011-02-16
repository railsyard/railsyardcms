class Admin::NamespaceTestController < ActionController::Base
  cattr_accessor :test_value
  caches_embedded :cached_action
  
  def cached_action
    render :text => "Namespace cache test. value: #{test_value}"
  end
end

