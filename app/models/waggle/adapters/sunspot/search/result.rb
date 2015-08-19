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

          def facets
            if @facets.nil?
              @facets = configuration.facets.map do |facet|
                sunspot_facet = search.facet("#{facet.name}_facet")
                if sunspot_facet
                  Waggle::Adapters::Sunspot::Search::Facet.new(facet_config: facet, sunspot_facet: sunspot_facet)
                end
              end
              @facets.compact!
            end
            @facets
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

          def search
            @search ||= ::Sunspot.search Waggle::Item do
              fulltext query.q
              paginate page: page, per_page: per_page

              filters.each do |key, value|
                with(key, value)
              end

              configuration.facets.each do |facet|
                facet_indexed_name = "#{facet.name}_facet".to_sym
                exclude_filters = []
                if value = query.facet(facet.name)
                  exclude_filters << with(facet_indexed_name, value)
                end
                facet facet_indexed_name, exclude: exclude_filters
              end
            end
          end

          def configuration
            query.configuration
          end

          def filters
            query.filters
          end
        end
      end
    end
  end
end
