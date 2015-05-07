module CacheKeys
  module Custom
    # Generator for showcases_controller
    class Showcases
      def index(exhibit:)
        CacheKeys::ActiveRecord.new.generate(record: [exhibit.showcases, exhibit.collection])
      end
      def edit(showcase:)
        CacheKeys::ActiveRecord.new.generate(record: [showcase, showcase.collection])
      end
      def title(showcase:)
        CacheKeys::ActiveRecord.new.generate(record: [showcase, showcase.collection])
      end
    end
  end
end
