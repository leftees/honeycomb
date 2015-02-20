class ItemDecorator < Draper::Decorator
  delegate_all

  def is_parent?
    object.parent_id.nil?
  end

  def recent_children
    ItemsDecorator.new(children_query_recent)
  end

  def image_title
    if object.honeypot_image
      object.honeypot_image.title
    else
      nil
    end
  end

  def back_path
    if is_parent?
      h.collection_items_path(object.collection_id)
    else
      h.collection_item_children_path(object.collection_id, object.parent_id)
    end
  end

  def react_thumbnail()
    h.react_component 'Thumbnail', image: object.honeypot_image.url
  end

  def show_image_box
    h.react_component 'ItemShowImageBox', image: object.honeypot_image.url, itemID: object.id.to_s
  end

  def edit_path
    h.edit_item_path(object.id)
  end

  def page_title
    h.render partial: '/items/item_title', locals: { item: self }
  end

  private

  def children_query_recent
    children_query.recent(5)
  end

  def children_query
    @children_query ||= ItemQuery.new(object.children)
  end
end
