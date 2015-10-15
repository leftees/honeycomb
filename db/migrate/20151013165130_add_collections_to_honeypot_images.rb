class AddCollectionsToHoneypotImages < ActiveRecord::Migration
  def up
    add_column :honeypot_images, :collection_id, :integer
  end

  def down
    remove_column :honeypot_images, :collection_id
  end
end
