
# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [ :action_web_service, :action_mailer ]

  config.plugin_paths = ["#{RAILS_ROOT}/../../.."] # this should match the top level directory containing the 'embedded_actions' plugin
  config.plugins = [:embedded_actions]

  config.action_controller.cache_store = :file_store, "#{RAILS_ROOT}/tmp/cache"
  config.action_controller.perform_caching             = true

  config.action_controller.session = { :key => "_myapp_session", :secret => "x" * 30 }
end
