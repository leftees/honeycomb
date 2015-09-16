module Metadata
  class Configuration
    class Field
      TYPES = [:string, :html, :date]

      attr_reader :name, :type, :label, :multiple, :required, :defaultFormField, :optionalFormField, :order

      def initialize(name:, type:, label:, defaultFormField:, optionalFormField:, order:, multiple: false, required: false)
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
        @order = order
      end
    end
  end
end
