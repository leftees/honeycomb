class PageQuery
  attr_reader :relation

  def initialize(relation = Page.all)
    @relation = relation
  end

  def all
    relation
  end

  def ordered
    relation.order(:name)
  end

  delegate :find, to: :relation

  def build(args = {})
    relation.build(args)
  end

  def public_find(id)
    relation.find_by!(unique_id: id)
  end

  def can_delete?
    true
  end
end
