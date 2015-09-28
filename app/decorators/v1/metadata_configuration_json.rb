module V1
  class MetadataConfigurationJSON
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def as_json(_options = {})
      {
        "@context" => "http://schema.org",
        "@type" => "DECMetadataConfiguration",
        fields: build_json_hash,
        facets: configuration.facets,
        sorts: configuration.sorts,
      }
    end

    def to_json(_options = {})
      as_json(_options).to_json
    end

    private

    def build_json_hash
      {}.tap do |hash|
        configuration.fields.each do |field|
          hash[field.name] = field.as_json
        end
      end
    end
  end
end
