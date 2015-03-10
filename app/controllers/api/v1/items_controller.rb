module API
  module V1
    class ItemsController < APIController

      def index
        @collection = CollectionJSONDecorator.new(CollectionQuery.new.public_find(params[:collection_id]))
      end

      def show
        @item = ItemQuery.new.public_find(params[:id])
      end
    end
  end
end
