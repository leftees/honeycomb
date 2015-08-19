module Metadata
  class Configuration
    class Facet
      attr_reader :field, :field_name, :name

      def initialize(name:, field:, field_name:, label: nil)
        @name = name
        @field = field
        @field_name = field_name
        @label = label
      end

      def label
        @label || field.label
      end
    end
  end
end
