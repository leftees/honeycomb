class AddCopyrightFromExhibitsToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :copyright, :text
  end
end
