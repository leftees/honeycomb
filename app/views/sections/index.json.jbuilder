json.set! :sections do
  json.array! @section_list.sections do |section|
    json.partial! 'show', section: section
  end
end
