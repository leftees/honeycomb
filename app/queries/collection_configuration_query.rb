class CollectionConfigurationQuery
  attr_reader :collection

  def initialize(collection)
    @collection = collection
  end

  def config
    collection.collection_configuration
  end
end
