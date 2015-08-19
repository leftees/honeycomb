module Waggle
  module Adapters
    module Sunspot
      module Search
        class Result
          attr_reader :query

          def initialize(query: query)
            @query = query
          end

          def hits
            @hits ||= search.hits.map { |sunspot_hit| Waggle::Adapters::Sunspot::Search::Hit.new(sunspot_hit) }
          end

          def page
            (query.start / per_page) + 1
          end

          def per_page
            query.rows
          end

          def total
            search.total
          end

          private

          def search # rubocop:disable Metrics/AbcSize
            @search ||= ::Sunspot.search Waggle::Item do
              fulltext query.q
              paginate page: page, per_page: per_page

              filters.each do |key, value|
                with(key, value)
              end

              query.configuration.facets.each do |facet|
                facet_indexed_name = "#{facet.name}_facet".to_sym
                exclude_filters = []
                if value = query.facet(facet.name)
                  exclude_filters << with(facet_indexed_name, value)
                end
                facet facet_indexed_name, exclude: exclude_filters
              end
            end
          end

          def filters
            query.filters
          end
        end
      end
    end
  end
end
