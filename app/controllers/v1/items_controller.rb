module V1
  # Version 1 API
  class ItemsController < APIController
    # API controller for items
    def index
      collection = CollectionQuery.new.public_find(params[:collection_id])
      @collection = CollectionJSONDecorator.new(collection)
      fresh_when([collection, collection.items])
    end

    def show
      @item = ItemQuery.new.public_find(params[:id])
      fresh_when(@item)
    end
  end
end
