module API
  module V1
    class ItemsController < APIController

      helper_method :collection

      def index
        items = collection.items
        @items = ItemJSONDecorator.decorate_collection(items)
      end

      def show
        item = collection.items.find(params[:id])
        @item = ItemJSONDecorator.new(item)
      end

      protected

        def collection
          @collection ||= Collection.find(params[:collection_id])
        end
    end
  end
end
