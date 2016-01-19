class AddMetadataToItems < ActiveRecord::Migration
  def change
    case ActiveRecord::Base.connection.class.name
    when /.*Mysql.*/
      add_column :items, :metadata, :text, limit: 4294967295
    else
      add_column :items, :metadata, :text
    end
  end
end
