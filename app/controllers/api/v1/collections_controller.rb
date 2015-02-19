module API
  module V1
    class CollectionsController < APIController

      def show
        collection = Collection.find(params[:id])
        @collection = CollectionJSONDecorator.new(collection)
      end
    end
  end
end
