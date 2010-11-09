# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_gmodnatdiv_session',
  :secret      => '7f3e7c0698ad138bb136fa3d701df7b4b4cae4fb62c11f5e914a8ed6c0b0eb9dc5930ccf2ef43be3d3618d9a08a39f54af8c5114980ba3439b291054ec26e695'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
