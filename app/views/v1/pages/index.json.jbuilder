@collection.display(json)
json.set! :pages do
  json.array! @collection.pages do |page|
    V1::PageJSONDecorator.display(page, json)
  end
end
