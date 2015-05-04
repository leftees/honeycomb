json.set! '@context', 'http://schema.org'
json.set! '@type', 'CreativeWork'
json.set! '@id', showcase_object.at_id
json.set! 'isPartOf/collection', showcase_object.collection_url
json.id showcase_object.unique_id
json.slug showcase_object.slug
json.title showcase_object.title
json.title showcase_object.title_line_1
json.title showcase_object.title_line_2
json.description showcase_object.description
json.image showcase_object.image
json.last_updated showcase_object.updated_at
