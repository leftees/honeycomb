json.set! '@context', 'http://schema.org'
json.set! '@type', 'CreativeWork'
json.set! '@id', item_object.json_ld_id
json.set! 'isPartOf/collection', item_object.collection_url
json.id item_object.unique_id
json.title item_object.title
json.image item_object.image
json.metadata item_object.metadata
