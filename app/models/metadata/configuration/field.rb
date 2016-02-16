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
        convert_keys_to_json!(json)

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
        convert_json_to_ruby_keys!(new_attributes)

        new_attributes.each do |key, value|
          send("#{key}=", value)
        end
        valid?
      end

      private

      def convert_keys_to_json!(json)
        json["defaultFormField"] = json.delete("default_form_field")
        json["optionalFormField"] = json.delete("optional_form_field")
      end

      def convert_json_to_ruby_keys!(hash)
        hash.to_hash.symbolize_keys!
        hash[:type] = hash[:type].to_sym if hash[:type]
        hash[:default_form_field] = hash.delete(:defaultFormField) if hash[:defaultFormField]
        hash[:optional_form_field] = hash.delete(:optionalFormField) if hash[:optionalFormField]

        convert_strings_to_booleans([:multiple, :required, :default_form_field, :optional_form_field], hash)
      end

      def convert_strings_to_booleans(keys, hash)
        keys.each do |key|
          hash[key] = hash[key] == "true" ? true : false if hash[key]
        end
      end
    end
  end
end
