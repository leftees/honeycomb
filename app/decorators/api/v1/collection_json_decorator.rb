module API
  module V1
    class CollectionJSONDecorator < Draper::Decorator
      def id
        h.api_v1_collection_url(object.id)
      end

      def name
        object.title
      end
    end
  end
end
