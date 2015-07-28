module Waggle
  module Search
    class Query
      DEFAULT_ROWS = 10

      attr_reader :q, :facets, :sort, :rows, :start, :collection

      def initialize(q:, facets: [], sort: nil, rows: nil, start: nil, collection: nil)
        @q = q
        @facets = facets
        @sort = sort
        @rows = (rows || DEFAULT_ROWS).to_i
        @start = (start || 0).to_i
        @collection = collection
      end

      def result
        @result ||= Waggle::Search::Result.new(query: self)
      end
    end
  end
end
