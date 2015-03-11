API::V1::CollectionJSONDecorator.display(@section.collection, json)
json.set! :showcases do
  API::V1::ShowcaseJSONDecorator.display(@section.showcase, json)

  json.set! :sections do
    API::V1::SectionJSONDecorator.display(@section, json)

    json.set! :item do
      API::V1::ItemJSONDecorator.display(@section.item, json)
      json.set! :children do
        json.array! @section.item.children do |child|
          API::V1::ItemJSONDecorator.display(child, json)
        end
      end

      json.set! :parent do
        API::V1::ItemJSONDecorator.display(@section.item.parent, json)
      end
    end
  end
end
