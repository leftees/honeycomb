module V1
  # Version 1 API
  class ItemsController < APIController
    # API controller for items
    def index
      collection = CollectionQuery.new.public_find(params[:collection_id])
      @collection = CollectionJSONDecorator.new(collection)

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Items,
                                           action: "index",
                                           collection: collection)
      fresh_when(etag: cache_key.generate)
    end

    def images
      @collection = CollectionQuery.new.public_find(params[:collection_id])

      render json: map_collection_items.to_json
    end

    def show
      @item = ItemQuery.new.public_find(params[:id])

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Items,
                                           action: "show",
                                           item: @item)
      fresh_when(etag: cache_key.generate)
    end

    def update
      @item = ItemQuery.new.public_find(params[:id])

      return if rendered_forbidden?(@item.collection)

      if SaveItem.call(@item, save_params)
        render :update
      else
        render :errors, status: :unprocessable_entity
      end
    end

    # get all showcases that use the given item
    def showcases
      @item = ItemQuery.new.public_find(params[:item_id])

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Items,
                                           action: "showcases",
                                           item: @item)
      fresh_when(etag: cache_key.generate)
    end

    protected

    def save_params
      params.require(:item).permit(
        :name,
        :description,
        :image,
        :manuscript_url,
        :transcription,
        :rights,
        :subject,
        :provenance,
        :call_number,
        :original_language,
        :uploaded_image,
        :alternate_name,
        :contributor,
        :publisher,
        :creator,
        date_created: [:value, :year, :month, :day, :bc, :display_text],
        date_modified: [:value, :year, :month, :day, :bc, :display_text],
        date_published: [:value, :year, :month, :day, :bc, :display_text],
        creator: [], # both :creator, and creator: [] are required bc it can pass null or an array.
        publisher: [], # both :publisher, and publisher: [] are required bc it can pass null or an array.
        alternate_name: [], # both :alternate_name, and alternate_name: [] are required bc it can pass null or an array.
        contributor: [], # both :contributor, and contributor: [] are required bc it can pass null or an array.
      )
    end

    private

    def map_collection_items
      @collection.items.map do |i|
        { unique_id: i.unique_id,
          thumb: i.honeypot_image.json_response["thumbnail/small"]["contentUrl"],
          image: i.honeypot_image.json_response["thumbnail/medium"]["contentUrl"],
          title: i.name }
      end
    end
  end
end
