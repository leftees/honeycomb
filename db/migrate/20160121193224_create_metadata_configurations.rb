class CreateMetadataConfigurations < ActiveRecord::Migration
  def change
    create_table :collection_configurations do |t|
      t.integer :collection_id, null: false
      t.jsonb :metadata, null: false, default: "{}"
      t.jsonb :sorts, null: false, default: "{}"
      t.jsonb :facets, null: false, default: "{}"
      t.timestamps
    end

    add_foreign_key :collection_configurations, :collections
  end
end
