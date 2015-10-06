class AddUrlToExhibits < ActiveRecord::Migration
  def change
    add_column :exhibits, :url, :string
  end
end
