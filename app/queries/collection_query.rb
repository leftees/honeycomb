class CollectionQuery
  attr_reader :search

  def initialize(relation = Collection.all)
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

  def build
    Collection.new
  end
end
