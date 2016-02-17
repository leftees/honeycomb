class CreateCollectionConfiguration
  attr_reader :collection

  def self.call(collection)
    new(collection).create
  end

  def initialize(collection)
    @collection = collection
  end

  def create
    return collection.collection_configuration if collection.collection_configuration

    collection.create_collection_configuration(
      metadata: base_config[:fields],
      sorts: base_config[:sorts],
      facets: base_config[:facets],
    )
  end

  private

  def base_config
    @base_config ||= YAML.load_file(Rails.root.join("config/metadata/", "item.yml"))
  end
end
