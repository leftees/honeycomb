module Migration
  class ItemMetadataConverter
    attr_reader :item

    def self.call
      Item.all.each do |item|
        self.new(item).convert!
      end
    end

    def initialize(item)
      @item = item
    end

    def convert!
      if !item.metadata["name"]
        item.metadata["name"] = [item.name]
      end

      if !item.metadata["description"]
        item.metadata["description"] = [item.description]
      end

      item.save!
    end
  end
end
