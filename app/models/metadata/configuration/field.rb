module Metadata
  class Configuration
    class Field
      include ActiveModel::Validations
      TYPES = [:string, :html, :date]

      attr_accessor :name, :active, :type, :label, :multiple, :required, :default_form_field,
                    :optional_form_field, :order, :placeholder, :help, :boost, :immutable

      validates :name, :type, :label, :order, presence: true
      validates :type, inclusion: TYPES

      def initialize(
        name:,
        active: true,
        type:,
        label:,
        default_form_field:,
        optional_form_field:,
        boost: 1,
        order:,
        help: "",
        placeholder: "",
        multiple: false,
        required: false,
        immutable: ["name"]
      )
        @name = name.to_sym
        @active = active
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
        @immutable = immutable

        if !valid?
          raise ArgumentError, errors.full_messages.join(", ")
        end
      end

      def as_json(options = {})
        json = super
        convert_keys_to_json!(json)

        json
      end

      def to_hash
        {
          name: name,
          active: active,
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
          immutable: immutable,
        }
      end

      def update(new_attributes)
        if name.present?
          new_attributes.delete(:name)
        end
        convert_json_to_ruby_keys!(new_attributes)

        if new_attributes.has_key?(:immutable)
          new_attributes[:immutable].delete("immutable")
          new_attributes[:immutable].delete(:immutable)
          send("immutable=", new_attributes[:immutable])
        end

        new_attributes.each do |key, value|
          send("#{key}=", value) unless key == :immutable || immutable.include?(key.to_s)
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

        convert_strings_to_booleans([:multiple, :required, :default_form_field, :optional_form_field, :active], hash)
      end

      def convert_strings_to_booleans(keys, hash)
        keys.each do |key|
          case hash[key]
          when "true"
            hash[key] = true
          when "false"
            hash[key] = false
          end
        end
      end
    end
  end
end
