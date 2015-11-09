class CopyDescriptionsToCollections < ActiveRecord::Migration
  class ExhibitMigration < ActiveRecord::Base
    self.table_name = "exhibits"
  end

  def up
    ExhibitMigration.find_each do |exhibit|
      site_intro = quote_string(string: exhibit.description)
      short_intro = quote_string(string: exhibit.short_description)
      execute "UPDATE collections SET site_intro = '#{site_intro}' WHERE id = #{exhibit.collection_id}" unless site_intro.nil?
      execute "UPDATE collections SET short_intro = '#{short_intro}' WHERE id = #{exhibit.collection_id}" unless short_intro.nil?
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
