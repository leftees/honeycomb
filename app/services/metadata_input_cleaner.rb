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
    if value.is_a?(Array)
      item.metadata.delete(key) if value.empty?
    else
      if value.nil?
        item.metadata.delete(key)
      else
        item.metadata[key] = value.is_a?(Hash) ? [ensure_hash(value)] : [value]
      end
    end
  end

  def ensure_hash(value)
    if value["0"]
      value["0"]
    else
      value
    end
  end
end
