module Metadata
  class Configuration
    class Facet
      attr_reader :field, :name

      def initialize(name:, field:, label: nil)
        @name = name
        @field = field
        @label = label
      end

      def label
        @label || field.label
      end
    end
  end
end
