module Metadata
  class Configuration
    attr_reader :data
    private :data

    def self.item_configuration
      @item_configuration ||= new(load_yml(:item))
    end

    def initialize(data)
      @data = data
    end

    def fields
      @fields ||= build_fields
    end

    def facets
      @facets ||= build_facets
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

    def facet(name)
      facet_map[name]
    end

    def facet?(name)
      facet(name).present?
    end

    def self.load_yml(name)
      YAML.load_file(Rails.root.join("config/metadata/", "#{name}.yml"))
    end
    private_class_method :load_yml

    private

    def field_map
      @field_map ||= build_field_map
    end

    def facet_map
      @facet_map ||= build_facet_map
    end

    def label_map
      @label_map ||= build_label_map
    end

    def build_fields
      data.fetch(:fields).map { |field_data| Metadata::Configuration::Field.new(**field_data) }
    end

    def build_facets
      data.fetch(:facets).map do |facet_data|
        facet_field = field(facet_data.fetch(:field_name))
        arguments = facet_data.merge(field: facet_field)
        Metadata::Configuration::Facet.new(**arguments)
      end
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

    def build_facet_map
      {}.tap do |hash|
        facets.each do |facet|
          hash[facet.name] = facet
        end
      end
    end
  end
end
