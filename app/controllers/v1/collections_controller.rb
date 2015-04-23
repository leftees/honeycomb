module V1
  class CollectionsController < APIController
    def index
      @collections = CollectionQuery.new.public_collections
      fresh_when(@collections)
    end

    def show
      @collection = CollectionQuery.new.public_find(params[:id])
      fresh_when(@collection)
    end
  end
end
