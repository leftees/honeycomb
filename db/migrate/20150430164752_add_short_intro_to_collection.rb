class AddShortIntroToCollection < ActiveRecord::Migration
  def change
    add_column :exhibits, :short_description, :text
  end
end
