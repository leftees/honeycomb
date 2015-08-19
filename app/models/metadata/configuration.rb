module Metadata
  class Configuration
    attr_reader :data
    private :data

    def self.build_fields(data)
      data.map { |field_data| self::Field.new(**field_data) }
    end

    def self.item_configuration
      @item_configuration ||= new(load_yml(:item))
    end

    def initialize(data)
      @data = data
    end

    def fields
      @fields ||= build_fields
    end

    def field(name)
      field_map[name]
    end

    def field?(name)
      field(name).present?
    end

    def label(name)
      label_map[name]
    end

    def label?(name)
      label(name).present?
    end

    def self.load_yml(name)
      YAML.load_file(Rails.root.join("config/metadata/", "#{name}.yml"))
    end
    private_class_method :load_yml

    private

    def build_fields
      data.fetch(:fields).map { |field_data| Metadata::Configuration::Field.new(**field_data) }
    end

    def field_map
      @field_map ||= build_field_map
    end

    def label_map
      @label_map ||= build_label_map
    end

    def build_field_map
      {}.tap do |hash|
        fields.each do |field|
          hash[field.name] = field
        end
      end
    end

    def build_label_map
      {}.tap do |hash|
        fields.each do |field|
          hash[field.label] = field
        end
      end
    end
  end
end
