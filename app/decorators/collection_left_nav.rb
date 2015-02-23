require 'draper'

class CollectionLeftNav < Draper::Decorator
  attr_reader :section

  def display(section)
    @section = section
    h.render partial: 'shared/collection_left_nav', locals: { nav: self }
  end

  def collection
    object
  end

  def active_section_css(test_section)
    "#{test_section == section ? 'selected' : ''}"
  end
end
