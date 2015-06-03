module CacheKeys
  module Custom
    # Generator for v1/items_controller
    class V1Items
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, collection.items])
      end

      def show(item:)
        CacheKeys::ActiveRecord.new.generate(record: [item, item.collection, item.children])
      end

      def showcases(item:)
        CacheKeys::ActiveRecord.new.generate(record: [item, item.collection, item.showcases])
      end
    end
  end
end
