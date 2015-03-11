V1::CollectionJSONDecorator.display(@section.collection, json)
json.set! :showcases do
  V1::ShowcaseJSONDecorator.display(@section.showcase, json)

  json.set! :sections do
    V1::SectionJSONDecorator.display(@section, json)

    json.set! :item do
      V1::ItemJSONDecorator.display(@section.item, json)
      json.set! :children do
        json.array! @section.item.children do |child|
          V1::ItemJSONDecorator.display(child, json)
        end
      end

      json.set! :parent do
        V1::ItemJSONDecorator.display(@section.item.parent, json)
      end
    end

    json.set! :nextSection do
      V1::SectionJSONDecorator.display(@section.next, json)
    end
    json.set! :previousSection do
      V1::SectionJSONDecorator.display(@section.next, json)
    end
  end
end
