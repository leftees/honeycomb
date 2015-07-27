module Waggle
  module Search
    class Result
      attr_reader :query

      def initialize(query: query)
        @query = query
      end

      def hits
        items.map { |item| Waggle::Search::Hit.new(item) }
      end

      def start
        query.start
      end

      def rows
        query.rows
      end

      def total
        @total ||= item_relation.count
      end

      private

      def collection
        query.collection
      end

      def items
        item_relation.limit(rows).offset(start)
      end

      def item_relation
        collection ? collection.items : Item.all
      end
    end
  end
end
