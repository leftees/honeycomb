@collection.display(json)
json.set! :items do
  json.array! @collection.items do |item|
    V1::ItemJSONDecorator.display(item, json)
  end
end
