class AddShowPageTitleToExhibit < ActiveRecord::Migration
  def change
    add_column :exhibits, :show_page_title, :boolean
  end
end
