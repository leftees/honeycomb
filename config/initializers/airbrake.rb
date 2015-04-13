Airbrake.configure do |config|
  config.api_key = '2623bd51a7b11b8e98fe8186e67898b3'
  config.host    = 'errbit.library.nd.edu'
  config.port    = 443
  config.secure  = config.port == 443
end
