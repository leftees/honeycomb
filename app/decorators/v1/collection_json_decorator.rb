
module V1
  class CollectionJSONDecorator < Draper::Decorator
    delegate :id, :title, :unique_id, :updated_at

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
      @items ||= ItemQuery.new(object.items).only_top_level
    end

    def showcases
      @showcases ||= ShowcaseQuery.new(object.showcases).published
    end

    def image
      if object.exhibit.honeypot_image
        object.exhibit.honeypot_image.json_response
      else
        nil
      end
    end
        def display(json, includes = {})
      json.partial! '/v1/collections/collection', collection_object: self
    end
  end
end

