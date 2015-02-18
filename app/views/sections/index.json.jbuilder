json.set! :sections do
  json.array! @sections.sections do | section |
    json.id section.id
    json.title section.title
    json.description section.description
    json.image section.image
    json.caption section.caption
    json.order section.order
    json.display_type SectionType.new(section).type
  end
end
