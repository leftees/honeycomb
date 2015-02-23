class CollectionUserQuery
  attr_reader :relation

  def initialize(relation = CollectionUser.all)
    @relation = relation
  end

  def all
    relation.all
  end
end
