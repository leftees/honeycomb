module CacheKeys
  module Custom
    # Generator for v1/collections_controller
    class V1Collections
      def index(collections:)
        exhibits = ExhibitQuery.new.for_collections(collections: collections)
        CacheKeys::ActiveRecord.new.generate(record: [collections, exhibits])
      end

      def show(collection:)
        CacheKeys::ActiveRecord.new.generate(record: collection)
      end
    end
  end
end
