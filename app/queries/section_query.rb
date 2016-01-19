class SectionQuery
  attr_reader :relation

  def initialize(relation = Section.all)
    @relation = relation
  end

  def ordered
    relation.order(:order)
  end

  def public_find(id)
    relation.find_by!(unique_id: id)
  end

  delegate :find, to: :relation

  def build(args = {})
    relation.build(args)
  end

  def next(section)
    order_field = Section.arel_table[:order]
    relation.where(showcase_id: section.showcase_id).where(order_field.gt(section.order)).order(order: :asc).first
  end

  def previous(section)
    order_field = Section.arel_table[:order]
    relation.where(showcase_id: section.showcase_id).where(order_field.lt(section.order)).order(order: :desc).first
  end
end
