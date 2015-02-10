json.set! '@context', 'http://schema.org'
json.set! '@type', 'CreativeWork'
json.set! '@id', item.id
json.name item.name
json.image item.image
json.set! 'isPartOf/collection', item.collection
