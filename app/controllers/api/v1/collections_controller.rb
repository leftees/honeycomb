module API
  module V1
    class CollectionsController < APIController

      def index
        @collections = CollectionQuery.new.public_collections
      end

      def show
        collection = Collection.find(params[:id])
        @collection = CollectionJSONDecorator.new(collection)
      end
    end
  end
end
