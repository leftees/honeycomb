module CacheKeys
  class DecoratedActiveRecord
    def generate(record:)
      record.instance_exec() { ActiveSupport::Cache.expand_cache_key(object) }
    end
  end
end
