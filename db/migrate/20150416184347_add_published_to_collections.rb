class AddPublishedToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :published, :boolean
    add_index :collections, :published
  end
end
