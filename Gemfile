if RUBY_VERSION =~ /1.9/
   Encoding.default_external = Encoding::UTF_8
   Encoding.default_internal = Encoding::UTF_8
end

source 'http://rubygems.org'

gem 'mysql2',   '0.2.6'     if ENV['DB'].nil? || ENV['DB'] == "mysql"
gem 'sqlite3',  '1.3.4'     if ENV['DB'].nil? || ENV['DB'] == "sqlite"
gem 'pg',       '0.11.0'    if ENV['DB'].nil? || ENV['DB'] == "postgres"

gem 'rails',                '3.0.11'
gem 'jquery-rails',         '1.0.18'
gem 'string-utils',         '0.2.0'
gem 'omniauth',             '1.0.0'
gem 'devise',               '1.5.0'
gem 'ancestry',             '1.2.4'
gem 'acts_as_list-rails3',  '0.0.4'
gem 'cancan',               '1.6.7'
gem 'gravatar_image_tag',   '1.0.0'
gem 'themes_for_rails',     '0.4.2'
gem 'cells',                '3.7.0'
gem 'rake',                 '0.9.2'
gem 'paperclip',            '2.4.5'
gem 'ckeditor',             '3.6.3'
gem 'acts_as_commentable',  '3.0.1'
gem 'recaptcha', :require => "recaptcha/rails", :git => 'http://github.com/ambethia/recaptcha.git', :ref => 'a9efec169a86299629cce7a414590d5055257086'

# For deploying on Heroku
# gem 'heroku', '2.14.0'
# gem 'aws-s3', '0.6.2'

# Example of snippet got via external gem ## broken in production due to bluecloth
# gem 'railsyard-markdown-content', :path => 'vendor/gems/railsyard-markdown-content'

group :development, :test do	
  gem 'rspec', '>= 2.5.0'
  gem 'rspec-rails', '>= 2.5.0'
  gem 'cucumber', '>= 0.10.2'
  gem 'cucumber-rails', '>= 0.4.1'
  gem 'webrat', '>= 0.7.3'
  gem 'capybara', '>= 1.0.0'
  gem 'deadweight', '>=0.2.1'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'railroady'
  # you don't need guard to test on travis
  unless ENV['TRAVIS']
    gem 'guard'
    gem 'guard-cucumber'
#    gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
    gem 'growl_notify'
  end
end
