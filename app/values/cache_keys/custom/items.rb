module CacheKeys
  module Custom
    # Generator for items_controller
    class Items
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, collection.items])
      end
      def edit(decorated_item:)
        CacheKeys::ActiveRecord.new.generate(record: [decorated_item.collection, decorated_item.recent_children, decorated_item.object])
      end
    end
  end
end
