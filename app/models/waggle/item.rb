module Waggle
  class Item
    TYPE = "Item"
    attr_reader :data

    def self.from_item(item)
      api_data = V1::ItemJSONDecorator.new(item).to_hash
      new(api_data)
    end

    def initialize(data)
      @data = data
    end

    def id
      data.fetch("id")
    end

    def unique_id
      id
    end

    def at_id
      data.fetch("@id")
    end

    def collection_id
      data.fetch("collection_id")
    end

    def type
      TYPE
    end

    def last_updated
      @last_updated ||= Time.zone.parse(data.fetch("last_updated")).utc.strftime("%Y-%m-%dT%H:%M:%SZ")
    end

    def thumbnail_url
      if thumbnail
        thumbnail["contentUrl"]
      end
    end

    def metadata
      @metadata ||= Waggle::Metadata::Set.new(data.fetch("metadata"), metadata_configuration)
    end

    def method_missing(method_name, *args, &block)
      if metadata_facet?(method_name)
        metadata_facet_value(method_name)
      elsif metadata_sort_field?(method_name)
        metadata_sort_value(method_name)
      elsif metadata_field?(method_name)
        metadata_field_value(method_name)
      else
        super
      end
    end

    def respond_to?(method_name, include_private = false)
      if metadata_facet?(method_name) || metadata_sort_field?(method_name) || metadata_field?(method_name)
        true
      else
        super
      end
    end

    def self.load(id)
      ItemQuery.new.public_find(id)
    end

    private

    def metadata_field?(method_name)
      metadata.field?(method_name)
    end

    def metadata_field_value(method_name)
      metadata.value(method_name)
    end

    def metadata_facet?(method_name)
      name = facet_name(method_name)
      name && metadata.facet?(name)
    end

    def metadata_facet_value(method_name)
      name = facet_name(method_name)
      if name
        metadata.facet(name)
      end
    end

    def metadata_sort_field?(method_name)
      name = sort_name(method_name)
      name && metadata.sort?(name)
    end

    def metadata_sort_value(method_name)
      name = sort_name(method_name)
      if name
        metadata.sort(name)
      end
    end

    # Facet values are available on Waggle::Item by calling waggle_item.<facet name>_facet
    def facet_name(method_name)
      if method_name.to_s =~ /_facet$/
        method_name.to_s.gsub(/_facet$/, "").to_sym
      end
    end

    # Facet values are available on Waggle::Item by calling waggle_item.<facet name>_facet
    def sort_name(method_name)
      if method_name.to_s =~ /_sort$/
        method_name.to_s.gsub(/_sort$/, "").to_sym
      end
    end

    def metadata_configuration
      ::Metadata::Configuration.item_configuration
    end

    def image
      data.fetch("image")
    end

    def thumbnail
      if image
        image["thumbnail/small"]
      end
    end
  end
end
