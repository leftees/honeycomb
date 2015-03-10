module API
  module V1
    class CollectionJSONDecorator < Draper::Decorator
      delegate :id, :title, :description, :unique_id, :image, :updated_at

      def self.display(collection, json)
        new(collection).display(json)
      end

      def at_id
        h.api_v1_collection_url(object.unique_id)
      end

      def items_url
        h.api_v1_collection_items_url(object.unique_id)
      end

      def showcases_url
        h.api_v1_collection_showcases_url(object.unique_id)
      end

      def slug
        CreateURLSlug.call(object.title)
      end

      def items
        @items ||= ItemQuery.new(object.items).published
      end

      def showcases

      end

      def display(json, includes = {})
        json.partial! 'api/v1/collections/collection', collection_object: self
      end
    end
  end
end
