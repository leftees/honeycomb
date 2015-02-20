class ShowcaseQuery
  attr_reader :relation

  def initialize(relation = Showcase.all)
    @relation = relation
  end

  def all
    relation
  end

  def find(id)
    relation.find(id)
  end

  def build(args = {})
    relation.build(args)
  end


end
