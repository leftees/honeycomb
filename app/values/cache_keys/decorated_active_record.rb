module CacheKeys
  class DecoratedActiveRecord
    def initialize(list: list)
      @list = list.flatten
    end

    def generate()
      keys = []
      @list.each do |decoratedObject|
        keys.push ActiveSupport::Cache.expand_cache_key(decoratedObject.object)
      end
      keys.join('/')
    end
  end
end
