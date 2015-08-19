module Waggle
  module Adapters
    module Sunspot
      module Search
        class FacetValue
          attr_reader :sunspot_facet_row
          private :sunspot_facet_row

          def initialize(sunspot_facet_row)
            @sunspot_facet_row = sunspot_facet_row
          end

          def name
            value
          end

          def value
            sunspot_facet_row.value
          end

          def count
            sunspot_facet_row.count
          end
        end
      end
    end
  end
end
