# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_warroom_rails2_session_id',
  :secret      => '1c44e06409d4d48a6e32a0859f7be77e67bc03f4bcb794e2ed111fdba3cec543a9cfb3bc99037e10fb1440b7a1ce39b206c1298be16cd4add31170c5a1ce6148'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
