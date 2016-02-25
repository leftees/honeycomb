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
      ensure_value_is_array(key, value)
    end

    item.metadata.stringify_keys!
  end

  private

  def ensure_value_is_array(key, value)
    if !value.is_a?(Array)
      if value.nil?
        item.metadata[key] = []
      else
        item.metadata[key] = value.is_a?(Hash) ? [value["0"]] : [value]
      end
    end
  end
end
