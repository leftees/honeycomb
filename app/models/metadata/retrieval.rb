module Metadata
  class Retrieval
    attr_reader :item

    def initialize(item)
      @item = item
    end

    def fields
      @fields ||= {}.tap do |hash|
        item.metadata.keys.each do |key|
          hash[key] = field(key)
        end
      end
    end

    def field(field)
      metadata_value(field)
    end

    def field?(field)
      get(field).present?
    end

    private

    def configuration
      @configuration ||= Metadata::Configuration.new(CollectionConfigurationQuery.new(item.collection).find)
    end

    def get(field)
      item.metadata[field.to_s]
    end

    def metadata_value(field)
      value = get(field)
      config = configuration.field(field)

      return nil if value.nil? || config.nil?

      type = config.type
      value = ensure_value_is_array(value)

      if type.to_sym == :string
        string_value(value)
      elsif type.to_sym == :html
        html_value(value)
      elsif type.to_sym == :date
        date_value(value)
      else
        raise "missing type"
      end
    end

    def string_value(value)
      value.map { |v| MetadataString.new(v) }
    end

    def html_value(value)
      value.map { |v| MetadataHTML.new(v) }
    end

    def date_value(value)
      value.map { |v| MetadataDate.new(v.symbolize_keys) }
    end

    def ensure_value_is_array(value)
      if value.is_a?(Array)
        value
      else
        [value]
      end
    end
  end
end
