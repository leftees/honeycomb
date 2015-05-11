module V1
  class CollectionsController < APIController
    def index
      @collections = CollectionQuery.new.public_collections

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Collections,
                                           action: "index",
                                           collections: @collections)
      fresh_when(etag: cache_key.generate)
    end

    def show
      @collection = CollectionQuery.new.public_find(params[:id])

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Collections,
                                           action: "show",
                                           collection: @collection)
      fresh_when(etag: cache_key.generate)
    end

    def publish
      @collection = CollectionQuery.new.any_find(params[:collection_id])
      @return_value = Publish.call(@collection)

      respond_to do |format|
        format.json { render json: { status: @return_value }.to_json }
      end
    end

    def unpublish
      @collection = CollectionQuery.new.any_find(params[:collection_id])
      @return_value = Unpublish.call(@collection)

      respond_to do |format|
        format.json { render json: { status: @return_value }.to_json }
      end
    end
  end
end
