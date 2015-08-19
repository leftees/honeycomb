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
      @last_updated ||= Time.zone.parse(data.fetch("last_updated")).utc
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
      if metadata.field?(method_name)
        metadata.value(method_name)
      else
        super
      end
    end

    def respond_to?(method_name, include_private = false)
      if metadata.field?(method_name)
        true
      else
        super
      end
    end

    def self.load(id)
      ItemQuery.new.public_find(id)
    end

    private

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
