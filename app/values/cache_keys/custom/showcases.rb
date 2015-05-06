module CacheKeys
  module Custom
    # Generator for showcases_controller
    class Showcases
      def index(exhibit:)
        CacheKeys::ActiveRecord.new.generate(record: [exhibit.showcases, exhibit.collection])
      end
      # Default cache key using the showcase and it's associated collection
      def default(showcase:)
        CacheKeys::ActiveRecord.new.generate(record: [showcase, showcase.collection])
      end
    end
  end
end
