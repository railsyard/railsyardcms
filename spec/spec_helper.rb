require 'rubygems'
require 'spork'

Spork.prefork do

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'rspec/rails/mocha'
  require 'capybara/rspec'
  require 'vcr'

  # VCR Specs
  VCR.config do |c|
    c.cassette_library_dir = 'spec/cassettes'
    c.stub_with :webmock
    c.allow_http_connections_when_no_cassette = true
  end

  RSpec.configure do |config|
    config.mock_with :mocha

    ### Database Cleaner ###
    require 'database_cleaner'
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean_with(:truncation)
    end
    config.before(:each) { DatabaseCleaner.clean }

    ### Capybara
    Capybara.default_driver = :rack_test
    Capybara.javascript_driver = :webkit
    Capybara.default_selector = :css
    Capybara.ignore_hidden_elements = true
  end

end

Spork.each_run do
  require Rails.root.join("config/routes.rb")
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  I18n.reload!
end
