
module V1
  class SectionJSONDecorator < Draper::Decorator
    delegate :id, :title, :description, :collection, :unique_id, :updated_at

    def self.display(section, json)
      new(section).display(json)
    end

    def at_id
      h.v1_section_url(object.unique_id)
    end

    def collection_url
      h.v1_collection_url(object.showcase.collection.unique_id)
    end

    def showcase_url
      h.v1_showcase_url(object.showcase.unique_id)
    end

    def slug
      CreateURLSlug.call(object.title)
    end

      def image
        {
                    width: "1200 px",
                    height: "1600 px",
                    contentUrl: "https://placekitten.com/g/1200/1600",
                    name: "1200x1600.jpg",
                    "thumbnail/medium" => {
                        width: "600 px",
                        height: "800 px",
                        contentUrl: "https://placekitten.com/g/600/800"
                    },
                    "thumbnail/dzi" => {
                        width: "1200 px",
                        height: "1600 px",
                        contentUrl: "https://honeypotpprd.library.nd.edu/images/honeycomb/000/002/000/056/pyramid/1200x1600.tif.dzi"
                    },
                    "thumbnail/small" => {
                        width: "150 px",
                        height: "200 px",
                        contentUrl: "https://placekitten.com/g/150/200"
                    }
        }
      end

    def display(json)
      json.partial! 'api/v1/sections/section', section_object: self
    end

  end
end

