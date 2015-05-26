Rails.application.configure do
  # cache_key_header is a value that will get prepended
  # to all generated cache key strings prior to MD5 digesting
  config.cache_key_header = (Time.now + rand).to_i.to_s + "/"
end
