V1::CollectionJSONDecorator.display(@page.collection, json)
json.set! :pages do
  @page.display(json)
  json.set! :nextObject do
    V1::SiteObjectsJSONDecorator.display(@page.next, json) if @page.next.present?
  end
  json.set! :previousObject do
    V1::SiteObjectsJSONDecorator.display(@page.previous, json) if @page.previous.present?
  end
end
