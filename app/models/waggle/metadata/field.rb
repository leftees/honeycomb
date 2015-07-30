module Waggle
  module Metadata
    class Field
      attr_reader :data, :type, :name, :label, :values
      private :data

      def initialize(data)
        @type = data.fetch("@type")
        @name = data.fetch("name")
        @label = data.fetch("label")
        @values = build_values(data.fetch("values"))
      end

      private

      def build_values(values_data)
        values_data.map { |value| Waggle::Metadata::Value.from_hash(value) }
      end
    end
  end
end
