class AddShowcaseToHoneypot < ActiveRecord::Migration
  def change
    add_column :honeypot_images, :showcase_id, :integer
  end
end
