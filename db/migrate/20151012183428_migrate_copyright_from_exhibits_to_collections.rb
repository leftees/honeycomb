class MigrateCopyrightFromExhibitsToCollections < ActiveRecord::Migration
  class ExhibitMigration < ActiveRecord::Base
    self.table_name = "exhibits"
  end

  def up
    add_column :collections, :copyright, :text
    ExhibitMigration.find_each do |exhibit|
      copyright = exhibit.copyright
      execute "UPDATE collections SET copyright = '#{copyright}' WHERE id = #{exhibit.collection_id}" unless copyright.nil?
    end
    ExhibitMigration.reset_column_information
  end

  def down
    remove_column :collections, :copyright
    ExhibitMigration.reset_column_information
  end
end
