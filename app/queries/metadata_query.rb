class MetadataQuery
  attr_reader :collection_id

  def initialize(collection_id:)
    @collection_id = collection_id
  end

  def max_order
    results = ActiveRecord::Base.connection.execute(
      "SELECT MAX(CAST(metadata::json->>'order' AS INTEGER)) as max_order
       FROM (SELECT json_array_elements(metadata::json) as metadata
             FROM \"collection_configurations\"
             WHERE \"collection_configurations\".\"collection_id\" = #{collection_id}) as collection_metadata;"
    )
    results.first["max_order"].to_i
  end
end
