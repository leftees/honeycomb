module ApplicationHelper
  def image_zoom(image_name, options = {})
    @image_zoom_id ||= 0
    @image_zoom_id += 1
    id ||= "imageZoom#{@image_zoom_id}"
    options = options.reverse_merge({
      id: id,
      class: "image-zoom image-zoom-immediate",
      style: "width: 100%; height: 100%",
      "data-target" => image_name,
    }).with_indifferent_access
    overlay = options.delete("overlay")
    caption = options.delete("caption")
    item = options.delete("item")
    if overlay
      options["data-overlay"] = overlay.to_json
    end
    if item
      content = item_attribution(item)
    else
      content = "".html_safe
    end
    if caption
      content += caption_container(caption)
    end
    zoom_content = content_tag(:div, content, options)
  end

  def display_errors(obj)
    ErrorMessages.new(obj).display_error
  end

  def masquerade
    @masquerade ||= Masquerade.new(self)
  end

  def permission
    @permission ||= SitePermission.new(current_user, self)
  end

  def collection_title(collection,  section_title = nil)
    page_title(collection.title, collection_items_path(collection), section_title, nil, edit_collection_path(collection))
  end

  def item_title(item)
    page_title(item.collection.title, collection_items_path(collection), item.title, collection_item_path(item.collection,item), edit_collection_path(item.collection))
  end

  def page_title(title, title_href = "", small_title = "", small_title_href = "", settings_href = "")
    content_for(:page_title) do
      Waggle::PageTitle.new(title).display do | pt |
        pt.small_title = small_title
        pt.title_href = title_href
        pt.small_title_href = small_title_href
        pt.settings_href = settings_href
      end
    end
  end

end
