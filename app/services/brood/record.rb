module Brood
  class Record
    attr_reader :record, :original_data, :brood_collection

    def initialize(record:, data:, brood_collection:)
      @record = record
      @original_data = data
      @brood_collection = brood_collection
    end

    def grow
      data.each do |key, value|
        record.send("#{key}=", value)
      end
    end

    def self.grow(klass:, data:, brood_collection:)
      record = klass.find_or_initialize_by(unique_id: data["unique_id"])
      brood_record = new(record: record, data: data, brood_collection: brood_collection)
      brood_record.grow
      brood_record
    end

    def data
      @data ||= {}.with_indifferent_access.tap do |hash|
        skipped = {}
        original_data.each do |key, original_value|
          value = brood_value(original_value)
          if record.respond_to?("#{key}=")
            hash[key] = value
          else
            skipped[key] = value
          end
        end
        if skipped.present?
          append_skipped_values(hash, skipped)
        end
      end
    end

    def append_skipped_values(data, values)
      if record.respond_to?(:description)
        debug "Appending values to #{record}#description: #{values}"
        append_values_to_description(data, values)
      else
        debug "Discarding values on #{record}: #{values}"
      end
    end

    def append_values_to_description(data, values)
      if data[:description].present?
        data[:description] += "\n\n"
      else
        data[:description] = ""
      end
      description_append = values.map { |key, value| "#{key.to_s.titleize}: #{value}" }
      data[:description] += description_append.join("\n")
    end

    def brood_value(value)
      if value.is_a?(Hash)
        if value["relationship"]
          find_record(value["relationship"])
        elsif value["file"]
          open_file(value["file"])
        else
          value
        end
      else
        value
      end
    end

    def find_record(value)
      klass_string, unique_id = value.split("/")
      klass = "::#{klass_string}".constantize
      klass.where(unique_id: unique_id).take!
    end

    def open_file(file)
      File.open(brood_collection.path("files/#{file}"))
    end

    def debug(message)
      Rails.logger.debug "[Brood::Record] #{message}"
    end
  end
end
