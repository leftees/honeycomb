module Metadata
  class Configuration
    class Field
      TYPES = [:string, :html, :date]

      attr_reader :name, :type, :label, :multiple, :required, :defaultFormField, :optionalFormField, :formOrder

      def initialize(name:, type:, label:, defaultFormField:, optionalFormField:, formOrder:, multiple: false, required: false)
        unless TYPES.include?(type.to_sym)
          raise ArgumentError, "Invalid type: #{type}.  Must be one of #{TYPES.join(', ')}"
        end
        @name = name.to_sym
        @type = type.to_sym
        @label = label
        @multiple = multiple
        @required = required
        @defaultFormField = defaultFormField
        @optionalFormField = optionalFormField
        @formOrder = formOrder
      end
    end
  end
end
