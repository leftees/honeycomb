module Waggle
  def self.adapter
    self::Adapters::Solr
  end

  def self.index(*objects)
    adapter.index(*objects)
  end

  def self.index!(*objects)
    adapter.index!(*objects)
  end

  def self.remove(*objects)
    adapter.remove(*objects)
  end

  def self.remove!(*objects)
    adapter.remove!(*objects)
  end

  def self.commit
    adapter.commit
  end

  def self.search(**args)
    set_configuration(::Metadata::Configuration.new(CollectionConfigurationQuery.new(args[:collection]).find))
    args.delete(:collection)
    Waggle::Search::Query.new(**args).result
  end

  def self.configuration
    @configruation
  end

  def self.set_configuration(configuration)
    @configruation = configuration
  end
end
