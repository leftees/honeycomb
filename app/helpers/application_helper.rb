module ApplicationHelper

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
      PageTitle.new(title).display do | pt |
        pt.small_title = small_title
        pt.title_href = title_href
        pt.small_title_href = small_title_href
        pt.settings_href = settings_href
      end
    end
  end

end
