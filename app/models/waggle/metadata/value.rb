module Waggle
  module Metadata
    module Value
      TYPE_MAP = {
        "MetadataDate" => self::Date,
        "MetadataHTML" => self::HTML,
        "MetadataString" => self::String,
      }.freeze

      def self.from_hash(hash)
        type = hash.fetch("@type")
        type_class = TYPE_MAP.fetch(type)
        type_class.new(hash)
      end
    end
  end
end
