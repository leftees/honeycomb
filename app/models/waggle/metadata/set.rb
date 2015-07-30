module Waggle
  module Metadata
    class Set
      attr_reader :data, :configuration

      def initialize(data, configuration)
        @data = data
        @values = {}
        @configuration = configuration
      end

      def value(field_name)
        @values[field_name] ||= raw_data(field_name).fetch("values").map { |v| v.fetch("value") }
      end

      def field?(field_name)
        configuration.field?(field_name)
      end

      private

      def raw_data(field_name)
        data.fetch(field_name.to_s, "values" => [])
      end
    end
  end
end
