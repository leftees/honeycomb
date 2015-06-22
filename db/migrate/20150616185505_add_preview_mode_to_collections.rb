class AddPreviewModeToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :preview_mode, :boolean
    add_index :collections, :preview_mode
  end
end
