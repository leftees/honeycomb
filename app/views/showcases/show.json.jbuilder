json.title @showcase.title
json.description @showcase.description
json.set! :sections do
  json.array! @showcase.sections do | section |
    json.partial! 'sections/show', section: section
  end
end
