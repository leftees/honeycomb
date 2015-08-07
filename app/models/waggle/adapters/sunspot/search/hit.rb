module Waggle
  module Adapters
    module Sunspot
      module Search
        class Hit
          attr_reader :sunspot_hit
          private :sunspot_hit

          def initialize(sunspot_hit)
            @sunspot_hit = sunspot_hit
          end

          def name
            stored(:name)
          end

          def at_id
            stored(:at_id)
          end

          def unique_id
            stored(:unique_id)
          end

          def collection_id
            stored(:collection_id)
          end

          def type
            stored(:type)
          end

          def thumbnail_url
            stored(:thumbnail_url)
          end

          def last_updated
            stored(:last_updated)
          end

          private

          def stored(field)
            value = sunspot_hit.stored(field)
            if value.is_a?(Array)
              value.first
            else
              value
            end
          end
        end
      end
    end
  end
end
