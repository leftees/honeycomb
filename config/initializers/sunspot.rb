require "sunspot/rails"

# The only functionality we're using from sunspot_rails is it's session and configuration functionality
Sunspot.session = Sunspot::Rails.build_session
