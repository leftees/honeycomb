@collection.display(json)
json.array! @collection.items do |item|
  API::V1::ItemJSONDecorator.display(item, json)
end
