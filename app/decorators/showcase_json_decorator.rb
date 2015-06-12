
class ShowcaseJSONDecorator < V1::ShowcaseJSONDecorator
  def at_id
    h.showcase_url(object.id)
  end

  def collection_url
    h.collection_url(object.collection.id)
  end
end
