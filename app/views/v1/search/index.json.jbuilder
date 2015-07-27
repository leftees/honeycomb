json.set! "@type", "SearchResult"
json.hits do
  json.found @search.total
  json.start @search.start
  json.hit @search.hits do |hit|
    json.partial! "v1/search/hit", hit: hit
  end
end
json.facets []
