module Metadata
  class UpdateConfigurationField
    attr_reader :collection

    def self.call(collection, field, new_data)
      new(collection).update_field(field, new_data)
    end

    def initialize(collection)
      @collection = collection
    end

    def update_field(field, new_data)
      configuration.save_field(field, new_data)
    end

    private

    def configuration
      @configuration ||= CollectionConfigurationQuery.new(collection).find
    end
  end
end
