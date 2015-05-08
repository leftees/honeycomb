module CacheKeys
  module Custom
    # Generator for sections_controller
    class Sections
      def edit(section:)
        CacheKeys::ActiveRecord.new.generate(record: [section, section.collection])
      end
    end
  end
end
