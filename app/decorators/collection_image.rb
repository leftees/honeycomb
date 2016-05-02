class CollectionImage
  attr_reader :collection

  def initialize(collection)
    @collection = collection
  end

  def display
    if collection.honeypot_image
      HoneypotThumbnail.display(collection.honeypot_image)
    elsif first_item_with_image
      HoneypotThumbnail.display(first_item_with_image.honeypot_image)
    else
      ""
    end
  end

  private

  def first_item_with_image
    @first_item_with_image ||= collection.items.joins(:honeypot_image).first
  end
end
