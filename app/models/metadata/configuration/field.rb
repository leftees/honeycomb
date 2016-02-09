module Metadata
  class Configuration
    class Field
      include ActiveModel::Validations
      TYPES = [:string, :html, :date]

      attr_accessor :name, :type, :label, :multiple, :required, :default_form_field, :optional_form_field, :order, :placeholder, :help, :boost

      validates :name, :type, :label, :order, presence: true
      validates :type, inclusion: TYPES

      def initialize(
        name:,
        type:,
        label:,
        default_form_field:,
        optional_form_field:,
        boost: 1,
        order:,
        help: "",
        placeholder: "",
        multiple: false,
        required: false
      )
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
        @placeholder = placeholder
        @help = help
        @boost = boost
      end

      def as_json(options = {})
        json = super
        json["defaultFormField"] = json.delete("default_form_field")
        json["optionalFormField"] = json.delete("optional_form_field")

        json
      end

      def to_hash
        {
          name: name,
          type: type,
          label: label,
          multiple: multiple,
          required: required,
          default_form_field: default_form_field,
          optional_form_field: optional_form_field,
          order: order,
          placeholder: placeholder,
          help: help,
          boost: boost,
        }
      end

      def update(new_attributes)
        if name.present?
          new_attributes.delete(:name)
        end

        new_attributes.each do |key, value|
          send("#{key}=", value)
        end
        valid?
      end
    end
  end
end
