class CopyExistingShowcasesToSiteObjects < ActiveRecord::Migration
  class ShowcaseMigration < ActiveRecord::Base
    self.table_name = "showcases"
  end
  class CollectionMigration < ActiveRecord::Base
    self.table_name = "collections"
  end

  def up
    # For each collection, get a list of showcases (in the order that the API currently retrieves them)
    # and construct an array of hashes that are of the form { :type, :id }
    # Ex: [{"type":"showcase","id":3},{"type":"showcase","id":1}]
    CollectionMigration.find_each do |collection|
      site_objects = []
      ShowcaseMigration.where(collection_id: collection.id).order(:order, :name_line_1).each do |showcase|
        site_objects << { type: "Showcase", id: showcase.id }
      end
      collection.site_objects = ActiveSupport::JSON.encode(site_objects)
      collection.save
    end

    CollectionMigration.reset_column_information
    ShowcaseMigration.reset_column_information
  end

  def down
    CollectionMigration.reset_column_information
    ShowcaseMigration.reset_column_information
  end
end
