class MigrateAboutFromExhibitsToCollections < ActiveRecord::Migration
  class ExhibitMigration < ActiveRecord::Base
    self.table_name = "exhibits"
  end

  def up
    add_column :collections, :about, :text
    ExhibitMigration.find_each do |exhibit|
      about = exhibit.about
      execute "UPDATE collections SET about = '#{about}' WHERE id = #{exhibit.collection_id}" unless about.nil?
    end
    ExhibitMigration.reset_column_information
  end

  def down
    remove_column :collections, :about
    ExhibitMigration.reset_column_information
  end
end
