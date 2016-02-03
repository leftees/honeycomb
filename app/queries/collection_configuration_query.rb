class CollectionConfigurationQuery
  attr_reader :collection

  def initialize(collection)
    @collection = collection
  end

  def find
    Metadata::Configuration.set_item_configuration(collection.collection_configuration)
  end
end
