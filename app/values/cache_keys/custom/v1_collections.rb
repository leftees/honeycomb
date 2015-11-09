module CacheKeys
  module Custom
    # Generator for v1/collections_controller
    class V1Collections
      def index(collections:)
        CacheKeys::ActiveRecord.new.generate(record: [collections])
      end

      def show(collection:)
        CacheKeys::ActiveRecord.new.generate(record: collection)
      end

      def site_objects(collection:, site_objects:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, site_objects])
      end
    end
  end
end
