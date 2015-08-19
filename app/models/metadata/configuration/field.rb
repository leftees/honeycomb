module Metadata
  class Configuration
    class Field
      TYPES = [:string, :html, :date]

      attr_reader :name, :type, :label, :multiple, :required

      def initialize(name:, type:, label:, multiple: false, required: false)
        unless TYPES.include?(type.to_sym)
          raise ArgumentError, "Invalid type: #{type}.  Must be one of #{TYPES.join(', ')}"
        end
        @name = name.to_sym
        @type = type.to_sym
        @label = label
        @multiple = multiple
        @required = required
      end
    end
  end
end
