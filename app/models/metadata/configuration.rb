module Metadata
  class Configuration
    attr_reader :fields, :field_map, :label_map
    private :field_map, :label_map

    def self.build_fields(data)
      data.map { |field_data| self::Field.new(**field_data) }
    end

    def self.item_configuration
      @item_configuration ||= new(load_yml(:item))
    end

    def initialize(data)
      @fields = self.class.build_fields(data)
      @field_map = build_field_map
      @label_map = build_label_map
    end

    def self.load_yml(name)
      YAML.load_file(Rails.root.join("config/metadata/", "#{name}.yml"))
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

    private_class_method :load_yml

    private

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
