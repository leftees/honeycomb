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
    if path == '#'
      link_to raw("<i class=\"glyphicon glyphicon-education\"></i> SUBMIT FEEDBACK"), 'https://docs.google.com/a/nd.edu/forms/d/1PH99cRyKzhZ6rV-dCJjrfkzdThA2n1GvoE9PT6kCkSk/viewform', :class => 'btn btn-large btn-hollow'
    else
      link_to raw("<i class=\"glyphicon glyphicon-education\"></i> #{t('buttons.help')}"), path, :class => 'btn btn-large btn-hollow'
    end
  end

  def back_button(path)
    link_to(raw("<span class=\"mdi-navigation-arrow-back\"></span>"), path, class: "btn btn-large btn-hollow")
  end


  def back_action_bar(back_path, learn_more_path)
    render(partial: '/shared/back_action_bar', locals: { back_path: back_path, learn_more_path: learn_more_path })
  end
end
