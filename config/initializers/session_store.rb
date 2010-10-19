# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rottenpotatoes_session',
  :secret      => '6acde4da22f75a017fba60bd13c82b41484aeaf013e5dbd2da4be884927565f6b042d31a10d0c6d7326cf5d31c1e13abf49c4e8808ab058ef92af9c0e36741a2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
