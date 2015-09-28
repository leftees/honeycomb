module Waggle
  module Search
    class Facet
      attr_reader :name, :field, :values

      def initialize(name:, field:, values:)
        @name = name
        @field = field
        @values = values || []
      end
    end
  end
end
