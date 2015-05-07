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
      h.collection_path(object.collection_id)
    else
      h.item_children_path(object.parent_id)
    end
  end

  def show_image_box
    h.react_component "ItemShowImageBox", image: image_json, itemID: object.id.to_s
  end

  def edit_path
    h.edit_item_path(object.id)
  end

  def page_title
    h.render partial: "/items/item_title", locals: { item: self }
  end

  private

  def image_json
    if object.honeypot_image
      object.honeypot_image.image_json
    else
      {}
    end
  end

  def children_query_recent
    children_query.recent(5)
  end

  def children_query
    @children_query ||= ItemQuery.new(object.children)
  end
end
