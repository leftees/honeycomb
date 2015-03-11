API::V1::CollectionJSONDecorator.display(@showcase.collection, json)
json.set! :showcases do
  API::V1::ShowcaseJSONDecorator.display(@showcase, json)

  json.set! :sections do
    json.array! @showcase.sections do | showcase |
      API::V1::SectionJSONDecorator.display(showcase, json)
    end
  end
end
