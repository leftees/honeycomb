class ExhibitQuery
  attr_reader :relation

  def initialize(relation = Exhibit.all)
    @relation = relation
  end

  delegate :find, to: :relation

  def for_collections(collections:)
    relation.where(collection: collections)
  end

  def all_external
    relation.where.not(url: nil)
  end

  def build(args = {})
    relation.build(args)
  end
end
