
module V1
  class ShowcaseJSONDecorator < Draper::Decorator
    delegate :id, :description, :collection, :unique_id, :updated_at, :name, :name_line_1, :name_line_2, :items

    def self.display(showcase, json)
      new(showcase).display(json)
    end

    def at_id
      h.v1_showcase_url(object.unique_id)
    end

    def collection_url
      h.v1_collection_url(object.collection.unique_id)
    end

    def description
      object.description.to_s
    end

    def slug
      CreateURLSlug.call(object.slug)
    end

    def additional_type
      "https://github.com/ndlib/honeycomb/wiki/Showcase"
    end

    def next
      SiteObjectsQuery.new.next(collection_object: object)
    end

    def previous
      SiteObjectsQuery.new.previous(collection_object: object)
    end

    def sections
      SectionQuery.new(object.sections).ordered
    end

    def image
      if object.honeypot_image
        object.honeypot_image.json_response
      else
        nil
      end
    end

    def display(json)
      if object.present?
        json.partial! "/v1/showcases/showcase", showcase_object: self
      end
    end
  end
end
