module Metadata
  class Configuration
    class Sort
      attr_reader :field, :field_name, :name, :direction, :active

      def initialize(name:, field:, field_name:, direction:, label: nil, active: true)
        @name = name
        @field = field
        @field_name = field_name
        @direction = direction
        @label = label
        @active = active
      end

      def label
        @label || field.label
      end
    end
  end
end
