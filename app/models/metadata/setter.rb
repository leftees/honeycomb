module Metadata
  class Setter
    attr_reader :item

    def self.call(item, metadata)
      new(item).set_metadata(metadata)
    end

    def initialize(item)
      @item = item
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

    def field?(field)
      item.item_metadata.field?(field)
    end
  end
end
