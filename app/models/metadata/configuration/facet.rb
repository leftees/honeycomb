module Metadata
  class Configuration
    class Facet
      attr_reader :field, :field_name, :name, :active

      def initialize(name:, field:, field_name:, label: nil, active: true)
        @name = name
        @field = field
        @field_name = field_name
        @label = label
        @active = active
      end

      def label
        @label || field.label
      end
    end
  end
end
