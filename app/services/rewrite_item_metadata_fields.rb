# Translates a hash of common property names to valid Item properties
class RewriteItemMetadataFields
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
          [configuration.label(k).name, v]
        else
          [k, v]
        end
      end
    ]
  end
end
