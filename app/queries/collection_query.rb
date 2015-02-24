class CollectionQuery
  attr_reader :relation

  def initialize(relation = Collection.all)
    @relation = relation
  end

  def for_top_nav(user, collection)
    for_curator(user).order(updated_at: :desc).where('id != ?', collection.id)
  end

  def for_curator(user)
    if UserIsAdmin.call(user)
      relation.all
    else
      user.collections
    end
  end

  def recent(limit = 5)
    relation.order(updated_at: :desc).limit(limit)
  end

  def find(id)
    relation.find(id)
  end

  def build
    relation.build
  end
end
