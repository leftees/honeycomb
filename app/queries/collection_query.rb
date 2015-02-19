class CollectionQuery
  attr_reader :search

  def initialize(relation = Exhibit.all)
    @search = relation
  end

  def for_curator(user)
    if UserIsAdmin.call(user)
      search.all
    else
      user.collections
    end
  end

  def find(id)
    Collection.find(id)
  end

end
