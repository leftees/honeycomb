module CacheKeys
  module Custom
    # Generator for editors_controller
    class Editors
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, collection.collection_users])
      end
      def user_search(collection:, users:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, users])
      end
    end
  end
end
