module V1
  class CollectionsController < APIController
    def index
      @collections = CollectionQuery.new.public_collections

      keyGen = CacheKeys::Generator::V1Collections.new
      cacheKey = CacheKeys::Generator.new(keyGenerator: keyGen, action: "index")
      print cacheKey.generate(record: @collections)
      fresh_when(etag: cacheKey.generate(record: @collections))
    end

    def show
      @collection = CollectionQuery.new.public_find(params[:id])
      fresh_when(@collection)

      keyGen = CacheKeys::Generator::V1Collections.new
      cacheKey = CacheKeys::Generator.new(keyGenerator: keyGen, action: "show")
      print cacheKey.generate(record: @collection)
      fresh_when(etag: cacheKey.generate(record: @collection))
    end
  end
end
