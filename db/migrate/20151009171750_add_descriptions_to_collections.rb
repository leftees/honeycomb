class AddDescriptionsToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :site_intro, :text
    add_column :collections, :short_intro, :text
  end
end
