class CopyCopyrightFromExhibitsToCollections < ActiveRecord::Migration
  class ExhibitMigration < ActiveRecord::Base
    self.table_name = "exhibits"
  end

  def up
    ExhibitMigration.find_each do |exhibit|
      copyright = quote_string(string: exhibit.copyright)
      execute "UPDATE collections SET copyright = '#{copyright}' WHERE id = #{exhibit.collection_id}" unless copyright.nil?
    end
    ExhibitMigration.reset_column_information
  end

  def down
    ExhibitMigration.reset_column_information
  end

  def quote_string(string:)
    string.nil? ? nil : ActiveRecord::Base.connection.quote_string(string)
  end
end
