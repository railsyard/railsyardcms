# Config inside config/evironments/development.rb and config/environments/production.rb

# Load mail configuration if not in test environment
# if RAILS_ENV != 'test'
#   email_settings = YAML::load(File.open("#{RAILS_ROOT}/config/mail.yml"))
#   ActionMailer::Base.smtp_settings = email_settings[RAILS_ENV] unless email_settings[RAILS_ENV].nil?
# end
