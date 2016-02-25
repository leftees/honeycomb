module Waggle
  module Search
    class SortField
      attr_reader :name, :value, :active

      def self.from_config(sort_configuration)
        new(name: sort_configuration.label, value: sort_configuration.name, active: sort_configuration.active)
      end

      def initialize(name:, value:, active: true)
        @name = name
        @value = value
        @active = active
      end
    end
  end
end
