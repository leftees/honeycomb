module V1
  class CollectionsController < APIController
    def index
      @collections = CollectionQuery.new.public_collections

      keyGen = CacheKeys::Generator::V1Collections.new
      cacheKey = CacheKeys::Generator.new(keyGenerator: keyGen, action: "index")
      fresh_when(etag: cacheKey.generate(collections: @collections))
    end

    def show
      @collection = CollectionQuery.new.public_find(params[:id])
      fresh_when(@collection)

      keyGen = CacheKeys::Generator::V1Collections.new
      cacheKey = CacheKeys::Generator.new(keyGenerator: keyGen, action: "show")
      fresh_when(etag: cacheKey.generate(collection: @collection))
    end
  end
end
