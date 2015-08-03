module V1
  class MetadataJSON < Draper::Decorator
    delegate :name, :creator, :alternate_name, :publisher, :rights, :original_language, :manuscript_url

    def self.metadata(item)
      new(item).metadata
    end

    METADATA_MAP = {
      name: { type: :string, label: "Name" },
      alternate_name: { type: :string, label: "Alternate Name" },
      creator: { type: :string, label: "Creator" },
      contributor: { type: :string, label: "Contributor" },
      description: { type: :html, label: "Description" },
      subject: { type: :html, label: "Subject" },
      transcription: { type: :html, label: "Transcription" },
      date_created: { type: :date, label: "Date Created" },
      date_published: { type: :date, label: "Date Published" },
      date_modified: { type: :date, label: "Date Modified" },
      original_language: { type: :string, label: "Original Language" },
      rights: { type: :string, label: "Rights" },
      provenance: { type: :string, label: "Provenance" },
      publisher: { type: :string, label: "Publisher" },
    }

    def metadata
      {}.tap do |hash|
        METADATA_MAP.each do |field, config|
          value = metadata_value(field)

          if value.present?
            hash[field] = {}
            hash[field]["@type"] = "MetadataField"
            hash[field]["name"] = field
            hash[field]["label"] = config[:label]
            hash[field]["values"] = metadata_hash(config[:type], value)
          end
        end
      end
    end

    private

    def metadata_value(field)
      value = object.send(field)

      if value.present?
        ensure_value_is_array(value)
      end
    end

    def metadata_hash(type, value)
      if type == :string
        string_value(value)
      elsif type == :html
        html_value(value)
      elsif type == :date
        date_value(value)
      else
        raise "missing type"
      end
    end

    def string_value(value)
      value.map { |v| MetadataString.new(v).to_hash }
    end

    def html_value(value)
      value.map { |v| MetadataHTML.new(v).to_hash }
    end

    def date_value(value)
      value.map { |v| MetadataDate.new(v.symbolize_keys).to_hash }
    end

    def ensure_value_is_array(value)
      if !value.is_a?(Array)
        return [value]
      end
      value
    end
  end
end
