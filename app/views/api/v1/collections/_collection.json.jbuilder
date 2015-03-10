json.set! '@context', 'http://schema.org'
json.set! '@type', 'CreativeWork'
json.set! '@id', collection_object.at_id
json.set! 'hasPart/items', collection_object.items_url
json.id collection_object.unique_id
json.slug collection_object.slug
json.title collection_object.title
json.description collection_object.description
json.last_updated collection_object.updated_at
json.image collection_object.image
