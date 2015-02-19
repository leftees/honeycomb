class CollectionQuery
  attr_reader :relation

  def initialize(relation = Collection.all)
    @relation = relation
  end

  def for_curator(user)
    if UserIsAdmin.call(user)
      relation.all
    else
      user.collections
    end
  end

  def find(id)
    relation.find(id)
  end

  def build
    relation.build
  end
end
