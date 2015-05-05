module CacheKeys
  # Replicates what Rails does for an ActiveRecord when generating a
  # cache key
  class ActiveRecord
    def generate(record:)
      ActiveSupport::Cache.expand_cache_key(record)
    end
  end
end
