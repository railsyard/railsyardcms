ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

# To test the embedded_actions plugin, we use a minimal rails setup located in the 'test/rails' directory.
# The following line loads that rails app environment
require 'application'
require 'test_controller'

require 'test/unit'  
require 'action_controller/test_process'

require 'test_help'

class Test::Unit::TestCase
  # Add more helper methods to be used by all tests here...


  def assert_embed_erb(result, erb, msg = nil)
    (class << @controller; self; end).send(:define_method, :test_action_for_assert_embed_erb, Proc.new do
      render :inline => erb
    end)
    
    get :test_action_for_assert_embed_erb
    assert_equal result, @response.body, msg
  end
end
