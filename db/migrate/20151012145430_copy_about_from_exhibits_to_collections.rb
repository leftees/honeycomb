class CopyAboutFromExhibitsToCollections < ActiveRecord::Migration
  class ExhibitMigration < ActiveRecord::Base
    self.table_name = "exhibits"
  end

  def up
    ExhibitMigration.find_each do |exhibit|
      about = quote_string(string: exhibit.about)
      execute "UPDATE collections SET about = '#{about}' WHERE id = #{exhibit.collection_id}" unless about.nil?
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
