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
      description: { type: :html, label: "Description" },
      transcription: { type: :html, label: "Transcription" },
      date_created: { type: :date, label: "Date Created" },
      date_published: { type: :date, label: "Date Published" },
      date_modified: { type: :date, label: "Date Modified" },
      original_language: { type: :string, label: "Original Language" },
      rights: { type: :string, label: "Rights" },
      publisher: { type: :string, label: "Publisher" },
    }

    def metadata
      {}.tap do |hash|
        METADATA_MAP.each do |field, config|
          value = metadata_value(field)
          if value
            hash[field] = metadata_hash(config[:type], value, config[:label])
          end
        end
      end
    end

    private

    def metadata_value(field)
      value = object.send(field)

      if value.present?
        value
      end
    end

    def metadata_hash(type, value, label)
      if type == :string
        string_value(value, label)
      elsif type == :html
        html_value(value, label)
      elsif type == :date
        date_value(value, label)
      else
        raise "missing type"
      end
    end

    def string_value(value, label)
      MetadataString.new(value).to_hash(label)
    end

    def html_value(value, label)
      MetadataHtml.new(value).to_hash(label)
    end

    def date_value(value, label)
      MetadataDate.new(value.symbolize_keys).to_hash(label)
    end
  end
end
