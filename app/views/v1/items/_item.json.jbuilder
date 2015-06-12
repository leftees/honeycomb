json.set! "@context", "http://schema.org"
json.set! "@type", "CreativeWork"
json.set! "@id", item_object.at_id
json.set! "isPartOf/collection", item_object.collection_url
json.id item_object.unique_id
json.slug CreateURLSlug.call(item_object.name)
json.name item_object.name
json.description item_object.description.to_s
json.image item_object.image
json.metadata item_object.metadata
json.creator item_object.creator
json.publisher item_object.publisher
json.alternateName item_object.alternate_name
json.rights item_object.rights
json.originalLanguage item_object.original_language
json.last_updated item_object.updated_at
