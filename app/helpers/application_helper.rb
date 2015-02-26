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

  def page_title(page_title)
    content_for(:page_title, page_title)
  end

  def collection_nav(collection, left_nav_section)
    content_for(:collection_top_nav, Nav::CollectionTop.new(collection).display)
    content_for(:left_nav, Nav::CollectionLeft.new(collection).display(left_nav_section))
  end

  def learn_more_button(path)
    link_to raw("<i class=\"glyphicon glyphicon-education\"></i> #{t('buttons.help')}"), path, :class => 'btn btn-large btn-hollow'
  end
end
