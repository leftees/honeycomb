class AddItemImageStatus < ActiveRecord::Migration
  def up
    add_column :items, :image_status, :integer, default: 0
    # Mark all items that have an associated honey pot image as having a status of image_ready
    # all others will be left with the default of 0, image_invalid
    execute "UPDATE items SET image_status = 2 where id in (select item_id from honeypot_images)"
  end

  def down
    remove_column :items, :image_status
  end
end
