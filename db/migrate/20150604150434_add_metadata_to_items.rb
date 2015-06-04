class AddMetadataToItems < ActiveRecord::Migration
  def change
    add_column :items, :metadata, :text, :limit => 4294967295
  end
end
