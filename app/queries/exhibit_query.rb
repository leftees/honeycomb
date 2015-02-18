class ExhibitQuery
  attr_reader :search

  def initialize(relation = Exhibit.all)
    @search = relation
  end

  def all_for_user(user)
    search.all
  end

end
