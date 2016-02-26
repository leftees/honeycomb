class CollectionConfigurationQuery
  attr_reader :collection

  def initialize(collection)
    @collection = collection
  end

  def find
    Metadata::Configuration.new(collection.collection_configuration)
  end

  def max_metadata_order
    config = find
    field = config.fields.max_by(& :order)
    if field.nil?
      0
    else
      field.order
    end
  end
end
