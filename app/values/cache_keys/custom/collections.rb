module CacheKeys
  module Custom
    # Generator for collections_controller
    class Collections
      def index(collections:)
        CacheKeys::ActiveRecord.new.generate(record: collections)
      end
      def edit(collection:)
        CacheKeys::ActiveRecord.new.generate(record: collection)
      end
    end
  end
end
