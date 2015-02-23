require 'draper'

class CollectionLeftNav < Draper::Decorator

  def display
    h.render partial: 'shared/collection_left_nav', locals: { nav: self }
  end

  def collection
    object
  end

end
