@collection.display(json)
json.set! :showcases do
  json.array! @collection.showcases do | showcase |
    API::V1::ShowcaseJSONDecorator.display(showcase, json)
  end
end
