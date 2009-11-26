# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_PicPocket_session',
  :secret      => '97f59275072d6e93ec909f6af7429ad4d533a7050e42b52069fe45090d20efdfe5e56e0f519468f3d882deb130973c760a96c4d78f3e319603a9369f8719aee8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
