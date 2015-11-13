
module V1
  class PageJSONDecorator < Draper::Decorator
    delegate :id, :collection, :unique_id, :updated_at, :name, :content

    def self.display(showcase, json)
      new(showcase).display(json)
    end

    def at_id
      h.v1_page_url(object.unique_id)
    end

    def collection_url
      h.v1_collection_url(object.collection.unique_id)
    end

    def slug
      CreateURLSlug.call(object.slug)
    end

    def additional_type
      "https://github.com/ndlib/honeycomb/wiki/Page"
    end

    def next
      SiteObjectsQuery.new.next(collection_object: object)
    end

    def previous
      SiteObjectsQuery.new.previous(collection_object: object)
    end

    def display(json)
      if object.present?
        json.partial! "/v1/pages/page", page_object: self
      end
    end
  end
end
