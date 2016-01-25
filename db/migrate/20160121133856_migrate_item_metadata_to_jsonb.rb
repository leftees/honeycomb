class MigrateItemMetadataToJsonb < ActiveRecord::Migration
  def change
    add_column :items, :metadata_jsonb, :jsonb, default: "{}"
    execute "UPDATE items SET metadata_jsonb = metadata::jsonb"
    execute "update items set metadata_jsonb = '{}' where metadata_jsonb is null"

    change_column :items, :metadata_jsonb, :jsonb, null: false
    rename_column :items, :metadata, :metadata_json
    rename_column :items, :metadata_jsonb, :metadata
  end
end
