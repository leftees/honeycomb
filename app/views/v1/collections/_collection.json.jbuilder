json.set! '@context', 'http://schema.org'
json.set! '@type', 'CreativeWork'
json.set! '@id', collection_object.at_id
json.set! 'hasPart/items', collection_object.items_url
json.set! 'hasPart/showcases', collection_object.showcases_url
json.id collection_object.unique_id
json.slug collection_object.slug
json.title collection_object.title
json.title collection_object.subtitle
json.description collection_object.site_intro
json.short_description collection_object.short_intro
json.image collection_object.image
json.last_updated collection_object.updated_at
