class CreateCollectionConfiguration
  attr_reader :collection, :config_file

  def self.call(collection, config_file = "item.yml")
    new(collection, config_file).create
  end

  def initialize(collection, config_file)
    @collection = collection
    @config_file = config_file
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
    @base_config ||= YAML.load_file(Rails.root.join("config/metadata/", config_file))
  end
end
