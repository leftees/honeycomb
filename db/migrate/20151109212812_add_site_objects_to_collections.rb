class AddSiteObjectsToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :site_objects, :text, limit: 4294967295
  end
end
