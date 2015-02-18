class AddCaptionToSections < ActiveRecord::Migration
  def change
    add_column :sections, :caption, :text
  end
end
