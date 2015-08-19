json.set! "@type", "SearchFacet"
json.name facet.name
json.field facet.field
json.values facet.values do |value|
  json.set! "@type", "SearchFacetValue"
  json.name value.fetch(:name)
  json.count value.fetch(:count)
end
