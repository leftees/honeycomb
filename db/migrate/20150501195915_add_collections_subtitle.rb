class AddCollectionsSubtitle < ActiveRecord::Migration
  def change
    add_column :collections, :subtitle, :string
  end
end
