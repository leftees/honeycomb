class AddPublishedToItems < ActiveRecord::Migration
  def change
    add_column :items, :published, :boolean
    add_index :items, :published
  end
end
