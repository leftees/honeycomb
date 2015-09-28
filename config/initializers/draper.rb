# Include the url_helpers to ensure Draper has the correct default_url_options
# Without this, Draper will not have default_url_options as defined in config/environments/<environment>.rb
module Draper
  class HelperProxy
    include Rails.application.routes.url_helpers
  end
end
