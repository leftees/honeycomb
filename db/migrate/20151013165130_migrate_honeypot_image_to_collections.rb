class MigrateHoneypotImageToCollections < ActiveRecord::Migration
  class HoneypotImage < ActiveRecord::Base
  end
  class Exhibit < ActiveRecord::Base
  end

  def up
    add_column :honeypot_images, :collection_id, :integer
    Exhibit.find_each do |exhibit|
      collection_id = exhibit.collection_id
      exhibit_id = exhibit.id
      execute "UPDATE honeypot_images SET collection_id = #{collection_id} WHERE exhibit_id = #{exhibit_id}"
    end

    Exhibit.reset_column_information
    Collection.reset_column_information
  end

  def down
    remove_column :honeypot_images, :collection_id

    Exhibit.reset_column_information
    Collection.reset_column_information
  end
end
