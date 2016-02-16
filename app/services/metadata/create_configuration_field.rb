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
      new_data = set_preset_values(new_data)
      configuration.save_field(new_data[:name], new_data)
    end

    private

    def configuration
      @configuration ||= CollectionConfigurationQuery.new(collection).find
    end

    def set_preset_values(new_data)
      new_data = new_data.to_hash.symbolize_keys

      new_data[:name] = new_data[:label].gsub(/\s/, "_").downcase
      new_data[:default_form_field] = new_data.delete(:defaultFormField) || "false"
      new_data[:optional_form_field] = new_data.delete(:optionalFormField) || "true"
      new_data[:order] = configuration.fields.size + 1

      new_data
    end
  end
end
