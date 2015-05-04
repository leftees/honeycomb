module V1
  class ShowcasesController < APIController
    def index
      collection = CollectionQuery.new.public_find(params[:collection_id])
      @collection = CollectionJSONDecorator.new(collection)

      keyGen = CacheKeys::Generator::V1Showcases.new
      cacheKey = CacheKeys::Generator.new(keyGenerator: keyGen, action: "index")
      fresh_when(etag: cacheKey.generate(collection: collection, showcases: collection.showcases))
    end

    def show
      showcase = ShowcaseQuery.new.public_find(params[:id])
      @showcase = ShowcaseJSONDecorator.new(showcase)

      keyGen = CacheKeys::Generator::V1Showcases.new
      cacheKey = CacheKeys::Generator.new(keyGenerator: keyGen, action: "show")
      fresh_when(etag: cacheKey.generate(showcase: showcase,
                                         collection: showcase.collection,
                                         sections: showcase.sections,
                                         items: showcase.items))
    end
  end
end
