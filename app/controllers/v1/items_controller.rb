module V1
  # Version 1 API
  class ItemsController < APIController
    # API controller for items
    def index
      collection = CollectionQuery.new.public_find(params[:collection_id])
      @collection = CollectionJSONDecorator.new(collection)

      keyGen = CacheKeys::Generator::V1Items.new
      cacheKey = CacheKeys::Generator.new(keyGenerator: keyGen, action: "index")
      fresh_when(etag: cacheKey.generate(collection: collection, items: collection.items))
    end

    def show
      @item = ItemQuery.new.public_find(params[:id])

      keyGen = CacheKeys::Generator::V1Items.new
      cacheKey = CacheKeys::Generator.new(keyGenerator: keyGen, action: "show")
      fresh_when(etag: cacheKey.generate(item: @item, collection: @item.collection, children: @item.children))
    end
  end
end
