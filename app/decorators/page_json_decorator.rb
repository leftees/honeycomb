class PageJSONDecorator < V1::PageJSONDecorator
  def at_id
    h.edit_page_url(object.id)
  end

  def image
    if object.image
      V1::ImageJSONDecorator.new(object.image).to_hash
    end
  end
end
