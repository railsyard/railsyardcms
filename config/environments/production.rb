# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
#config.cache_classes = true

# FIX-ME
#that will slow down a bit the app... I surrender, can't find any other solution, at least on rails 2.3.8
config.cache_classes = false #needed for avoiding unresolvable error: undefined method `before_post_process' for #<Class:0xbbb8a68> caused by method_missing_without_paginate
#example:
#*** Exception NoMethodError in PhusionPassenger::Railz::ApplicationSpawner (undefined method `before_post_process' for #<Class:0xbbb8a68>) (process 13911): 	from /opt/ruby-enterprise-1.8.7-2010.01/lib/ruby/gems/1.8/gems/activerecord-2.3.8/lib/active_record/base.rb:1994:in `method_missing_without_paginate'
#something similar explained here: http://www.ruby-forum.com/topic/164670

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
config.action_mailer.raise_delivery_errors = true

# Enable threaded mode
# config.threadsafe!

# !!! Gmail / Google Apps config !!!
ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => true,
    :address        => 'smtp.gmail.com',
    :port           => 587,
    :domain         => 'gmail.com',
    :authentication => :plain,
    :user_name      => 'example@gmail.com',
    :password       => 'example'
}


