module API
  module V1
    class ItemJSONDecorator < Draper::Decorator
      def id
        h.api_v1_collection_item_url(object.collection_id, object.id)
      end

      def name
        object.title
      end

      def image
        if object.honeypot_image
          object.honeypot_image.url
        else
          nil
        end
      end

      def collection
        h.api_v1_collection_url(object.collection_id)
      end
    end
  end
end
