module Metadata
  class CreateConfigurationField
    attr_reader :collection

    def self.call(collection, new_data)
      new(collection).create_field(new_data)
    end

    def initialize(collection)
      @collection = collection
    end

    def create_field(new_data)
      new_data = ConfigurationInputCleaner.call(new_data)
      configuration.save_field(new_data[:name], new_data)
    end

    private

    def configuration
      @configuration ||= CollectionConfigurationQuery.new(collection).find
    end
  end
end
