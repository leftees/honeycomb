module V1
  class CollectionsController < APIController
    def index
      @collections = CollectionQuery.new.public_collections

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Generator::V1Collections,
                                           action: "index",
                                           collections: @collections)
      fresh_when(etag: cache_key.generate)
    end

    def show
      @collection = CollectionQuery.new.public_find(params[:id])

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Generator::V1Collections,
                                           action: "show",
                                           collection: @collection)
      fresh_when(etag: cache_key.generate)
    end
  end
end
