module Waggle
  module Search
    class Result
      attr_reader :query

      def initialize(query: query)
        @query = query
      end

      def hits
        adapter_result.hits.map { |adapter_hit| Waggle::Search::Hit.new(adapter_hit) }
      end

      def start
        query.start
      end

      def rows
        query.rows
      end

      def total
        adapter_result.total
      end

      def facets
        @facets ||= [].tap do |array|
          array << Waggle::Search::Facet.new(
            name: "Creator",
            field: "creator",
            values: [
              { name: "Barlow, Dudley", count: 25 },
              { name: "Pinsker, Sanford", count: 21 },
              { name: "Salinger, J", count: 4 },
            ]
          )

          array << Waggle::Search::Facet.new(
            name: "Language",
            field: "original_language",
            values: [
              { name: "English", count: 5203 },
              { name: "Japanese", count: 87 },
              { name: "French", count: 65 },
            ]
          )
        end
      end

      private

      def adapter_result
        @adapter_result ||= Waggle.adapter.search_result(query: query)
      end
    end
  end
end
