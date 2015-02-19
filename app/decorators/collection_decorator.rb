class CollectionDecorator < Draper::Decorator
  delegate_all

  def item_count
    ItemQuery.new(object.items).parent_items.count
  end
end
