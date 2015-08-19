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
        adapter_result.facets
      end

      private

      def adapter_result
        @adapter_result ||= Waggle.adapter.search_result(query: query)
      end
    end
  end
end
