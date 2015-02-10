json.array! @items do |item|
  json.partial! 'item', item: item
end
