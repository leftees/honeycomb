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
end



