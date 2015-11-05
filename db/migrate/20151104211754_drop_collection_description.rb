class DropCollectionDescription < ActiveRecord::Migration
  def change
    remove_column :collections, :description
  end
end
