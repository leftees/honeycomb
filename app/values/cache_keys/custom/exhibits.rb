module CacheKeys
  module Custom
    # Generator for collections_controller
    class Exhibits
      def edit(exhibit:)
        CacheKeys::ActiveRecord.new.generate(record: [exhibit, exhibit.collection])
      end
    end
  end
end
