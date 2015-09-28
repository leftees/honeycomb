module Waggle
  module Search
    class Result
      attr_reader :query

      def initialize(query: query)
        @query = query
      end

      def hits
        @hits ||= adapter_result.hits.map { |adapter_hit| Waggle::Search::Hit.new(adapter_hit) }
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

      def sorts
        @sorts ||= [].tap do |array|
          array.push relevancy_sort
          configured_sorts.each do |sort_config|
            array.push Waggle::Search::SortField.from_config(sort_config)
          end
        end
      end

      private

      # The relevancy sort is purely for display purposes, since the default search sort is score.
      def relevancy_sort
        @relevancy_sort ||= Waggle::Search::SortField.new(name: "Relevance", value: "score")
      end

      def configured_sorts
        configuration.sorts
      end

      def configuration
        query.configuration
      end

      def adapter_result
        @adapter_result ||= Waggle.adapter.search_result(query: query)
      end
    end
  end
end
