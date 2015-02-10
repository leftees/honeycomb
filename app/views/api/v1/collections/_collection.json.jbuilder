json.set! '@context', 'http://schema.org'
json.set! '@type', 'CreativeWork'
json.set! '@id', collection_object.id
json.name collection_object.name
json.set! 'hasPart/items', collection_object.items
