# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_railsyard_session',
  :secret      => '3a5972f97ghdfn7hj049jhe19b388f43c37ed1a73a7ec3caee630ede8c34aa679d98642ae89ac0d7yugfheruj6314ec11e14d98f3ee202801bd8824'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

# Rack middleware for swfupload cookie fix
ActionController::Dispatcher.middleware.insert_before(ActionController::Session::CookieStore, FlashSessionCookieMiddleware, ActionController::Base.session_options[:key])
