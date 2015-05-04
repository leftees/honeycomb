
module V1
  class ShowcaseJSONDecorator < Draper::Decorator
    delegate :id, :description, :collection, :unique_id, :updated_at

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
      CreateURLSlug.call(object.title)
    end

    def title
      if title_line_2.present?
        "#{title_line_1} #{title_line_2}"
      else
        title_line_1
      end
    end

    def title_line_1
      object.title.to_s
    end

    def title_line_2
      object.subtitle.to_s
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
      json.partial! '/v1/showcases/showcase', showcase_object: self
    end
  end
end
