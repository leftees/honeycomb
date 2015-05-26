class ShowcaseQuery
  attr_reader :relation

  def initialize(relation = Showcase.all)
    @relation = relation
  end

  def all
    relation
  end

  def admin_list
    relation.order(:order, :title)
  end

  def public_api_list
    relation.order(:order, :title)
  end

  delegate :find, to: :relation

  def build(args = {})
    relation.build(args)
  end

  def public_find(id)
    relation.find_by!(unique_id: id)
  end

  def next(showcase)
    relation.
      where(exhibit_id: showcase.exhibit_id).
      where("`#{relation.table_name}`.order > ?", showcase.order).
      order(:order).
      first
  end

  def previous(showcase)
    relation.
      where(exhibit_id: showcase.exhibit_id).
      where("`#{relation.table_name}`.order < ?", showcase.order).
      order(order: :desc).
      first
  end
end
