module CacheKeys
  class ActiveRecord
    def initialize(list: list)
      @list = list.flatten
    end

    def generate()
      ActiveSupport::Cache.expand_cache_key(@list)
    end
  end
end
