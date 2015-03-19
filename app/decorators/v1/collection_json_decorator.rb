
module V1
  class CollectionJSONDecorator < Draper::Decorator
    delegate :id, :title, :description, :unique_id, :updated_at

    def self.display(collection, json)
      new(collection).display(json)
    end

    def at_id
      h.v1_collection_url(object.unique_id)
    end

    def items_url
      h.v1_collection_items_url(object.unique_id)
    end

    def showcases_url
      h.v1_collection_showcases_url(object.unique_id)
    end

    def description
      object.description.to_s
    end

    def site_intro
      object.exhibit.description.to_s
    end

    def slug
      CreateURLSlug.call(object.title)
    end

    def items
      @items ||= ItemQuery.new(object.items).published
    end

    def showcases
      @showcases ||= ShowcaseQuery.new(object.showcases).published
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

    def display(json, includes = {})
      json.partial! '/v1/collections/collection', collection_object: self
    end
  end
end

