class CollectionImage
  attr_reader :collection

  def initialize(collection)
    @collection = collection
  end

  def display
    if first_item_with_image
      item = ItemDecorator.new(first_item_with_image)
      item.react_thumbnail
    else
      ""
    end
  end

  private

    def first_item_with_image
      @first_item_with_image ||= collection.items.find { | i | i.honeypot_image }
    end

end