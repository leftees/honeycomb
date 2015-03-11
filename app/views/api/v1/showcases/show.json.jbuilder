API::V1::CollectionJSONDecorator.display(@showcase.collection, json)
json.set! :showcases do
  API::V1::ShowcaseJSONDecorator.display(@showcase, json)

  json.set! :sections do
    json.array! @showcase.sections do | section |
      API::V1::SectionJSONDecorator.display(section, json)
      json.set! :item do
        API::V1::ItemJSONDecorator.display(section.item, json)
      end
    end
  end
end
