class ItemQuery
  attr_reader :relation

  def initialize(relation = Item.all)
    @relation = relation
  end

  def recent(limit = 5)
    relation.order(updated_at: :desc).limit(limit)
  end

  def only_top_level
    relation.where(parent_id: nil)
  end

  def find(id)
    relation.find(id)
  end

  def build(args = {})
    relation.build(args)
  end

  def published
    relation.where(published: true)
  end

  def public_find(id)
    relation.find_by!(unique_id: id)
  end
end
