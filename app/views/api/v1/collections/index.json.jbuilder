json.array!(@collections) do |collection|
  json.partial! 'collection', collection_object: collection
end
