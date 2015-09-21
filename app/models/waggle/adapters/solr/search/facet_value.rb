module Waggle
  module Adapters
    module Solr
      module Search
        class FacetValue
          attr_reader :value, :count
          
          def initialize(facet_row)
            @value = facet_row[0]
            @count = facet_row[1]
          end

          def name
            value
          end
        end
      end
    end
  end
end
