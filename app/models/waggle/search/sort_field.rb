module Waggle
  module Search
    class SortField
      attr_reader :name, :value

      def self.from_config(sort_configuration)
        new(name: sort_configuration.label, value: sort_configuration.name)
      end

      def initialize(name:, value:)
        @name = name
        @value = value
      end
    end
  end
end
