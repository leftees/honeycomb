class CreateMetadataConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|
      t.integer :collection_id, null: false
      t.jsonb :metadata, null: false, default: "{}"
      t.jsonb :sorts, null: false, default: "{}"
      t.jsonb :facets, null: false, default: "{}"
      t.timestamps
    end

    add_foreign_key :configurations, :collections
  end
end
