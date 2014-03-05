# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
MyApp::Application.config.secret_token = if Rails.env.development? or Rails.env.test?
  "43171864c6b64df56b120c385d20043d776d23df304605623b9a0b7dc58954989d89ff4bde5e4f927cab904272173578b996fbd1a16f9b8be28993fc5a8dcf09" # meets minimum requirement of 30 chars long
else
  ENV['SECRET_TOKEN']
end
