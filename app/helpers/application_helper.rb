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

  def collection_title(collection)
    content_for(:collection_nav, CollectionTopNav.new(collection).display)
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
