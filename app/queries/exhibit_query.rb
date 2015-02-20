class ExhibitQuery
  attr_reader :relation

  def initialize(relation = Exhibit.all)
    @relation = relation
  end

  def find(id)
    relation.find(id)
  end

  def build(args = {})
    relation.build(args)
  end
end
