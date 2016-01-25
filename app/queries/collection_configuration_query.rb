class CollectionConfigurationQuery
  attr_reader :collection

  def initialize(collection)
    @collection = collection
  end

  def find
    collection.collection_configuration
  end
end
