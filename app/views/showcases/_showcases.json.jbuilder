json.array! @item.showcases do |showcase|
  ShowcaseJSONDecorator.display(showcase, json)
end
