class ItemQuery
  attr_reader :relation

  def initialize(relation = Item.all)
    @relation = relation
  end

  def recent(limit = 5)
    relation.order(updated_at: :desc).limit(limit)
  end

  def parent_items
    relation.where(parent_id: nil)
  end

  def find(id)
    relation.find(id)
  end

  def build(args = {})
    relation.build(args)
  end


end
