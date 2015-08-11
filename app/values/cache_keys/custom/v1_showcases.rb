module CacheKeys
  module Custom
    # Generator for v1/showcases_controller
    class V1Showcases
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, collection.exhibit, collection.showcases])
      end

      def show(showcase:)
        CacheKeys::ActiveRecord.new.generate(record: [showcase.object, showcase.collection, showcase.object.exhibit, showcase.sections, showcase.items, showcase.next])
      end
    end
  end
end
