json.array! @item.pages do |page|
  PageJSONDecorator.display(page, json)
end
