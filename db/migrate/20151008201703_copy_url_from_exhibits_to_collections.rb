class CopyUrlFromExhibitsToCollections < ActiveRecord::Migration
  class ExhibitMigration < ActiveRecord::Base
    self.table_name = "exhibits"
  end

  def up
    ExhibitMigration.find_each do |exhibit|
      url = quote_string(string: exhibit.url)
      execute "UPDATE collections SET url = '#{url}' WHERE id = #{exhibit.collection_id}" unless url.nil?
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
