API::V1::CollectionJSONDecorator.display(@item.collection, json)
json.set! :items do
  API::V1::ItemJSONDecorator.display(@item, json)
end
