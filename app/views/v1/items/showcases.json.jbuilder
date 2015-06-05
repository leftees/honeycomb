V1::CollectionJSONDecorator.display(@item.collection, json)
json.set! :items do
  V1::ItemJSONDecorator.display(@item, json)

  json.set! :showcases do
    json.array! @item.showcases do |showcase|
      V1::ShowcaseJSONDecorator.display(showcase, json)
    end
  end
end
