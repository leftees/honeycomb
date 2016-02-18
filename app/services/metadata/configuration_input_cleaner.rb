class Item < ActiveRecord::Base
end

module Metadata
  class ConfigurationInputCleaner
    attr_reader :data

    def self.call(data)
      new(data).clean!
    end

    def initialize(data)
      @data = data
    end

    def clean!
      ensure_symbols
      ensure_json_fields_are_converted
      ensure_name_from_label
      ensure_boolean_values

      data
    end

    private

    def ensure_boolean_values
      [:required, :default_form_field, :optional_form_field].each do |key|
        data[key] = convert_value_to_bool(data[key]) if data.has_key?(key)
      end
    end

    def convert_value_to_bool(value)
      case value
      when "true"
        true
      when "false"
        false
      when ""
        false
      else
        value
      end
    end

    def ensure_name_from_label
      if data[:label]
        data[:name] = data[:label].gsub(/\s/, "_").downcase
      end
    end

    def ensure_symbols
      @data = data.to_hash.symbolize_keys
    end

    def ensure_json_fields_are_converted
      data[:default_form_field] = data.delete(:defaultFormField) if data[:defaultFormField]
      data[:optional_form_field] = data.delete(:optionalFormField) if data[:optionalFormField]
    end
  end
end
