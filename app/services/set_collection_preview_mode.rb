class SetCollectionPreviewMode
  attr_reader :collection, :value

  def self.call(collection, value)
    new(collection, value).set_preview_mode
  end

  def initialize(collection, value)
    @collection = collection
    @value = value
  end

  def set_preview_mode
    collection.preview_mode = value
    collection.save
  end
end

