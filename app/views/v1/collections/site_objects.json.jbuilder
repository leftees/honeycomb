@collection.display(json)
json.set! :site_objects do
  json.array! @site_objects do |site_object|
    V1::SiteObjectsJSONDecorator.display(site_object, json)
  end
end
