module Metadata
  class Fields
    attr_reader :item

    include ActiveModel::Validations

    validates_with MetadataValidator

    def initialize(item)
      @item = item
    end

    def name
      if field?(:name) && field(:name)
        field(:name).first.value
      end
    end

    def description
      if field?(:description) && field(:description)
        field(:description).first.value
      end
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
      configuration.field_names.include?(field.to_s)
    end

    def set_metadata(metadata)
      metadata.each do |key, value|
        set(key, value)
      end
      MetadataInputCleaner.call(item)
    end

    private

    def set(field, value)
      if field?(field)
        item.metadata[field.to_s] = value
      end
    end

    def configuration
      @configuration ||= CollectionConfigurationQuery.new(item.collection).find
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
      method = value_method(type)

      send(method, value)
    end

    def value_method(type)
      if type.to_sym == :string
        "string_value"
      elsif type.to_sym == :html
        "html_value"
      elsif type.to_sym == :date
        "date_value"
      else
        raise "missing type"
      end
    end

    def string_value(value)
      if value.is_a?(Array)
        value.map { |v| Metadata::Fields::StringField.new(v) }
      else
        [Metadata::Fields::StringField.new(value)]
      end
    end

    def html_value(value)
      if value.is_a?(Array)
        value.map { |v| Metadata::Fields::HTMLField.new(v) }
      else
        [Metadata::Fields::HTMLField.new(value)]
      end
    end

    def date_value(value)
      if value.is_a?(Array)
        value.map { |v| Metadata::Fields::DateField.new(v.symbolize_keys) }
      else
        [Metadata::Fields::DateField.new(value.symbolize_keys)]
      end
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
