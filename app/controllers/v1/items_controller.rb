module V1
  # Version 1 API
  class ItemsController < APIController
    # API controller for items
    def index
      @collection = CollectionJSONDecorator.new(
        CollectionQuery.new.public_find(params[:collection_id]))
      fresh_when(@collection)
    end

    def show
      @item = ItemQuery.new.public_find(params[:id])
      fresh_when(@item)
    end
  end
end
