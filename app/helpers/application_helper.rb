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

  def collection_nav(collection, section)
    content_for(:collection_nav, CollectionTopNav.new(collection).display)
    content_for(:left_nav, CollectionLeftNav.new(collection).display(section))
  end


end
