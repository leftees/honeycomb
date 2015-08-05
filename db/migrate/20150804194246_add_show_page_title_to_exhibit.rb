class AddShowPageTitleToExhibit < ActiveRecord::Migration
  def change
    add_column :exhibits, :show_page_title, :boolean

    Exhibit.update_all(show_page_title: true)
  end
end
