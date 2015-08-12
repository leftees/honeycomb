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

          def search
            @search ||= ::Sunspot.search Waggle::Item do
              fulltext query.q
              paginate page: page, per_page: per_page

              filters.each do |key, value|
                with(key, value)
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
