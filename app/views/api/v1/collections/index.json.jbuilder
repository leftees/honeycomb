json.array!(@collections) do |collection|

  API::V1::CollectionJSONDecorator.display(collection, json)

end
