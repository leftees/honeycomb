module CacheKeys
  # Replicates what Rails does for an ActiveRecord when generating a
  # cache key, for decorated objects
  class DecoratedActiveRecord
    def generate(record:)
      record.instance_exec() { ActiveSupport::Cache.expand_cache_key(object) }
    end
  end
end
