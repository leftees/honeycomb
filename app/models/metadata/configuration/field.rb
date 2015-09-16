module Metadata
  class Configuration
    class Field
      TYPES = [:string, :html, :date]

      attr_reader :name, :type, :label, :multiple, :required, :default_form_field, :optional_form_field, :order

      def initialize(name:, type:, label:, default_form_field:, optional_form_field:, order:, multiple: false, required: false)
        unless TYPES.include?(type.to_sym)
          raise ArgumentError, "Invalid type: #{type}.  Must be one of #{TYPES.join(', ')}"
        end
        @name = name.to_sym
        @type = type.to_sym
        @label = label
        @multiple = multiple
        @required = required
        @default_form_field = default_form_field
        @optional_form_field = optional_form_field
        @order = order
      end

      def to_json
        json = as_json
        json["defaultFormField"] = json.delete("default_form_field")
        json["optionalFormField"] = json.delete("optional_form_field")

        json.to_json
      end
    end
  end
end
