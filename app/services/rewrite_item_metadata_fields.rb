# Translates a hash of common property names to valid Item properties
class RewriteItemMetadataFields
  attr_accessor :field_map

  def initialize(field_map: nil)
    @field_map = field_map || default_field_map
  end

  def rewrite(item_hash:)
    Hash[
      item_hash.map do |k, v|
        if field_map.key?(k)
          [field_map[k], v]
        else
          [k, v]
        end
      end
    ]
  end

  # TODO: Read this from the configs. Map label to item property
  def default_field_map
    {
      Identifier: :user_defined_id,
      Name: :name,
      :"Alternative Name" => :alternate_name,
      Description: :description,
      :"Date Created" => :date_created,
      Creator: :creator,
      Subject: :subject,
      :"Original Language" => :original_language
    }
  end
end
