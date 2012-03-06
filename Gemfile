if RUBY_VERSION =~ /1.9/
   Encoding.default_external = Encoding::UTF_8
   Encoding.default_internal = Encoding::UTF_8
end

source 'http://rubygems.org'

gem 'mysql2',   '0.3.11'     if ENV['DB'].nil? || ENV['DB'] == "mysql"
gem 'sqlite3',  '1.3.5'     if ENV['DB'].nil? || ENV['DB'] == "sqlite"
gem 'pg',       '0.11.0'    if ENV['DB'].nil? || ENV['DB'] == "postgres"

gem 'rails',                '3.2.1'
gem 'jquery-rails',         '1.0.18'
gem 'string-utils',         '0.2.0'
gem 'omniauth',             '1.0.0'
gem 'devise',               '1.5.0'
gem 'ancestry',             '1.2.4'
#gem 'acts_as_list',         '0.1.4'
gem 'cancan',               '1.6.7'
gem 'gravatar_image_tag',   '1.0.0'
gem 'themes_for_rails',     '0.4.3'
gem 'cells',                '3.8.0'
gem 'cells-filters',        '0.0.1'
gem 'paperclip',            '2.4.5'
#gem 'ckeditor',             '3.7.0.rc2'
gem 'ckeditor',             :path => 'vendor/gems/ckeditor'
gem 'acts_as_commentable',  '3.0.1'
gem 'recaptcha-rails3',		'0.3.4', :require => "recaptcha/rails"
gem 'will_paginate',        '3.0.2'

# For deploying on Heroku
# gem 'heroku', '2.14.0'
# gem 'aws-s3', '0.6.2'

# Example of snippet got via external gem ## broken in production due to bluecloth
# gem 'railsyard-markdown-content', :path => 'vendor/gems/railsyard-markdown-content'

group :test do
  gem 'spork'
  gem 'rspec-rails'
  gem 'rspec-rails-mocha', :require => false
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'vcr'
  gem 'capybara-webkit'
  gem 'webmock'
  gem 'launchy'

  gem 'cucumber'
  gem 'cucumber-rails'
end
