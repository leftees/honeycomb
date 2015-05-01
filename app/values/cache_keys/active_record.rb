module CacheKeys
  class ActiveRecord
    def generate(record:)
      ActiveSupport::Cache.expand_cache_key(record)
    end
  end
end
