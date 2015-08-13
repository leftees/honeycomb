class RenameExhibitTitleField < ActiveRecord::Migration
  def change
    rename_column :exhibits, :show_page_title, :hide_title_on_home_page
  end
end
