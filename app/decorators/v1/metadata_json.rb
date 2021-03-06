module V1
  class MetadataJSON < Draper::Decorator
    def self.metadata(item)
      new(item).metadata
    end

    def metadata
      {}.tap do |hash|
        object.item_metadata.fields.each do |key, metadata_field|
          field_config = configuration.field(key)

          if field_config.present? && metadata_field.present? && field_config.active
            hash[key] = field_hash(metadata_field, field_config)
          end
        end
      end
    end

    private

    def configuration
      @configuration ||= CollectionConfigurationQuery.new(object.collection).find
    end

    def field_hash(value, field_config)
      {
        "@type" => "MetadataField",
        "name" => field_config.name,
        "label" => field_config.label,
        "values" => value.map(&:to_hash),
      }
    end
  end
end
