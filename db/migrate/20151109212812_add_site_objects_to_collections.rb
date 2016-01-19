class AddSiteObjectsToCollections < ActiveRecord::Migration
  def change
    case ActiveRecord::Base.connection.class.name
    when /.*Mysql.*/
      add_column :collections, :site_objects, :text, limit: 4294967295
    else
      add_column :collections, :site_objects, :text
    end
  end
end
