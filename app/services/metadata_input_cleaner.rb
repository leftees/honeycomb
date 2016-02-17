class MetadataInputCleaner
  attr_reader :item

  def self.call(item)
    new(item).clean!
  end

  def initialize(item)
    @item = item
  end

  def clean!
    item.metadata.each do |key, value|
      if !value.is_a?(Array)
        item.metadata[key] = value["0"] ? value["0"] : [value]
      end
    end
  end
end
