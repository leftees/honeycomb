module CacheKeys
  module Custom
    # Generator for sections_controller
    class Pages
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, collection.pages])
      end

      def edit(page:)
        CacheKeys::ActiveRecord.new.generate(record: [page, page.collection])
      end
    end
  end
end
