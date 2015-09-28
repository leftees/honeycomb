module Metadata
  class Configuration
    class Sort
      attr_reader :field, :field_name, :name, :direction

      def initialize(name:, field:, field_name:, direction:, label: nil)
        @name = name
        @field = field
        @field_name = field_name
        @direction = direction
        @label = label
      end

      def label
        @label || field.label
      end
    end
  end
end
