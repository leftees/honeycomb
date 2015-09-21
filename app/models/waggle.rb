module Waggle
  def self.setup
    adapter.setup
  end

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
    Waggle::Search::Query.new(**args).result
  end
end
