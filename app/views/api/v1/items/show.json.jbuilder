API::V1::CollectionJSONDecorator.display(@item.collection, json)
json.set! :items do
  API::V1::ItemJSONDecorator.display(@item, json)

  json.set! :children do
    json.array! @item.children do |child|
      API::V1::ItemJSONDecorator.display(child, json)
    end
  end

  json.set! :parent do
    API::V1::ItemJSONDecorator.display(@item.parent, json)
  end
end
