module CacheKeys
  module Custom
    # Generator for exhibits_controller
    class Exhibits
      def edit(exhibit:)
        CacheKeys::ActiveRecord.new.generate(record: [exhibit, exhibit.collection])
      end
    end
  end
end
