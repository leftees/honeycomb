class ItemDecorator < Draper::Decorator
  delegate_all

  def is_parent?
    object.parent_id.nil?
  end

  def recent_children
    ItemsDecorator.new(children_query_recent)
  end

  def image_title
    image_decorator.title
  end

  def back_path
    if is_parent?
      h.collection_items_path(object.collection_id)
    else
      h.collection_item_children_path(object.collection_id, object.parent_id)
    end
  end

  def thumbnail(style_name = :small, options = {})
    image_decorator.render(style_name, options)
  end

  def react_thumbnail()
    h.react_component 'Thumbnail', image: object.honeypot_image.url
  end

  def render_image_zoom(options = {})
    image_decorator.render_image_zoom(options)
  end

  def edit_path
    h.edit_collection_item_path(object.collection_id, object.id)
  end

  def show_path
    h.collection_item_path(object.collection_id, object.id)
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

  def image_decorator
    @image_decorator ||= ItemImageDecorator.new(object.honeypot_image)
  end
end
