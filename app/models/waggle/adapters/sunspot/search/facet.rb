module Waggle
  module Adapters
    module Sunspot
      module Search
        class Facet
          attr_reader :sunspot_facet, :facet_config
          private :sunspot_facet, :facet_config

          def initialize(sunspot_facet:, facet_config:)
            @sunspot_facet = sunspot_facet
            @facet_config = facet_config
          end

          def name
            facet_config.label
          end

          def field
            facet_config.name
          end

          def values
            sunspot_facet.rows.map { |row| Waggle::Adapters::Sunspot::Search::FacetValue.new(row) }
          end
        end
      end
    end
  end
end
