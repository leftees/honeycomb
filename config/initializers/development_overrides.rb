if Rails.env.development?
  Rails.application.configure do
    if ENV["BACKGROUND_PROCESSING"]
      config.settings.background_processing = true
    end
  end
end
