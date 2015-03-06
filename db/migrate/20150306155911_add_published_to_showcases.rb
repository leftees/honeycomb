class AddPublishedToShowcases < ActiveRecord::Migration
  def change
    add_column :showcases, :published, :boolean
    add_index :showcases, :published
  end
end
