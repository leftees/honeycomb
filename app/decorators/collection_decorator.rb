class CollectionDecorator < Draper::Decorator
  delegate_all

  def item_count
    ItemQuery.new(object.items).only_top_level.count
  end
end
