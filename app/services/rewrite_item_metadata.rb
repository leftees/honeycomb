# Translates a hash of common property names to valid Item properties
class RewriteItemMetadata
  attr_reader :configuration
  private :configuration

  def initialize
    @configuration = Metadata::Configuration.item_configuration
  end

  def self.call(item_hash:)
    new.rewrite(item_hash: item_hash)
  end

  def rewrite(item_hash:)
    Hash[
      item_hash.map do |k, v|
        if configuration.label?(k)
          new_key = configuration.label(k).name
          [new_key, rewrite_value(field_name: new_key, value: v)]
        else
          [k, v]
        end
      end
    ]
  end

  def rewrite_value(field_name:, value:)
    result = value
    field = configuration.field(field_name)

    # Rewrite multiples into an array
    if field.multiple
      result = result.split("||")
    end

    if field.type.to_s == "date"
      result = MetadataDate.parse(value).to_params
    end

    result
  end

end
