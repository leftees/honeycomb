module API
  module V1
    class ItemJSONDecorator < Draper::Decorator
      delegate :id, :title, :unique_id, :updated_at

      METADATA_MAP = [
        ['Title', :title],
        ['Description', :description],
        ['Manuscript', :manuscript_url]
      ]

      def self.display(item, json)
        new(item).display(json)
      end

      def json_ld_id
        h.api_v1_collection_item_url(object.collection.unique_id, object.unique_id)
      end

      def collection_url
        h.api_v1_collection_url(object.collection.unique_id)
      end

      def image
        if object.honeypot_image
          object.honeypot_image.url
        else
          nil
        end
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

      def display(json)
        json.partial! 'api/v1/items/item', item_object: self
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
