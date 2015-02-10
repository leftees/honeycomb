module API
  module V1
    class ItemJSONDecorator < Draper::Decorator
      METADATA_MAP = [
        ['Title', :title],
        ['Description', :description],
        ['Manuscript', :manuscript_url]
      ]

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

      def metadata
        [].tap do |array|
          METADATA_MAP.each do |label, field|
            value = metadata_value(field)
            if value
              array << {label: label, value: value}
            end
          end
        end
      end

      private
        def metadata_value(field)
          value = object.send(field)
          if value.present?
            value
          else
            nil
          end
        end
    end
  end
end
