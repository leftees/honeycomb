class AddExhibitToHoneypotImage < ActiveRecord::Migration
  def change
    add_column :honeypot_images, :exhibit_id, :integer
  end
end
