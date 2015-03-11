
module V1
  class SectionJSONDecorator < Draper::Decorator
    delegate :id, :title, :description, :collection, :caption, :item, :unique_id, :updated_at

    def self.display(section, json)
      new(section).display(json)
    end

    def at_id
      h.v1_section_url(object.unique_id)
    end

    def collection_url
      h.v1_collection_url(object.collection.unique_id)
    end

    def showcase_url
      h.v1_showcase_url(object.showcase.unique_id)
    end

    def slug
      CreateURLSlug.call(object.title)
    end

    def display(json)
      json.partial! '/v1/sections/section', section_object: self
    end

  end
end

