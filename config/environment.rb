# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.11'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  # FIX to nasty error "A copy of ApplicationController has been removed from the module tree but is still active!"
  # see http://strd6.com/2009/04/cant-dup-nilclass-maybe-try-unloadable/
  config.reload_plugins = true
  
  # Needed for indexes on text attributes, MySQL hack ;-) 
  config.active_record.schema_format = :sql
  
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  config.autoload_paths += %W( #{RAILS_ROOT}/app/middleware )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
    
    config.gem 'mysql',                   :version => '~> 2.8.1',   :source => "http://gemcutter.org"
    config.gem 'ryanb-acts-as-list',      :version => '~> 0.1.2',   :source => 'http://gems.github.com', :lib => 'acts_as_list'
    config.gem 'hpricot',                 :version => '~> 0.8.2',   :source => "http://gemcutter.org"
    config.gem 'will_paginate',           :version => '~> 2.3.14',  :source => 'http://gemcutter.org'
    config.gem 'paperclip',               :version => '~> 2.3.3',   :source => 'http://gemcutter.org'
    config.gem 'wysihat-engine',          :version => '~> 0.1.13',  :source => 'http://gemcutter.org'
    config.gem 'acts_as_commentable',     :version => '2.0.2',      :source => 'http://gemcutter.org'
    config.gem 'capistrano',              :version => '~> 2.5.18',  :source => 'http://gemcutter.org'
    config.gem 'erubis',                  :version => '~> 2.6.5',   :source => 'http://gemcutter.org'
    config.gem 'string-utils',            :version => '~> 0.2.0',   :source => 'http://gemcutter.org'
    config.gem 'gravatar_image_tag',      :version => '~> 0.1.0',   :source => 'http://gemcutter.org'
    config.gem 'mime-types',              :version => '1.16',       :source => 'http://gemcutter.org',   :lib => "mime/types"
    config.gem 'restful_authentication',  :version => '~> 1.1.6',   :source => 'http://gemcutter.org'
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  config.active_record.observers = :user_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'
  #config.time_zone = 'Rome'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :en
  
end
# Author::    Silvio Relli  (mailto:silvio@relli.org)