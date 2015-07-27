module Waggle
  module Search
    class Hit < Draper::Decorator
      delegate :name

      def at_id
        h.v1_item_url(object.unique_id)
      end

      def type
        "Item"
      end

      def name
        object.name
      end

      def short_description
        "Short Description"
      end

      def description
        object.description.to_s
      end

      def thumbnail_url
        if object.honeypot_image
          object.honeypot_image.json_response["thumbnail/small"]["contentUrl"]
        else
          nil
        end
      end

      def updated
        object.updated_at.as_json
      end
    end
  end
end
