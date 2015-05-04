module V1
  class ShowcasesController < APIController
    def index
      collection = CollectionQuery.new.public_find(params[:collection_id])
      @collection = CollectionJSONDecorator.new(collection)

      cache_key = CacheKeys::Generator.new(keyGenerator: CacheKeys::Generator::V1Showcases,
                                           action: "index",
                                           collection: collection)
      fresh_when(etag: cache_key.generate)
    end

    def show
      showcase = ShowcaseQuery.new.public_find(params[:id])
      @showcase = ShowcaseJSONDecorator.new(showcase)

      cache_key = CacheKeys::Generator.new(keyGenerator: CacheKeys::Generator::V1Showcases,
                                           action: "show",
                                           showcase: showcase)
      fresh_when(etag: cache_key.generate)
    end
  end
end
