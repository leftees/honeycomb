json.set! "@context", "http://schema.org"
json.set! "@type", "CreativeWork"
json.set! "@id", page_object.at_id
json.set! "isPartOf/collection", page_object.collection_url
json.set! "additionalType", page_object.additional_type
json.id page_object.unique_id
json.slug page_object.slug
json.name page_object.name
json.content page_object.content
json.last_updated page_object.updated_at
