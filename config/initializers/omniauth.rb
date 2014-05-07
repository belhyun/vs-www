Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter , APP_CONFIG['twitter_key'], APP_CONFIG['twitter_secret']
  provider :facebook, '497472560379388', 'f1275ec765257e7f5f4d99201f0cd493'
end
