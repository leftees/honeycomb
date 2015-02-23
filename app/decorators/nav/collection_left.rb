require 'draper'

class Nav::CollectionLeft < Draper::Decorator
  attr_reader :left_nav_section

  def display(left_nav_section)
    @left_nav_section = left_nav_section
    h.render partial: 'shared/collection_left_nav', locals: { nav: self }
  end

  def collection
    object
  end

  def active_section_css(test_section)
    "#{test_section == left_nav_section ? 'selected' : ''}"
  end
end
