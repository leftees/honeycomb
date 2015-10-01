class AddSearchAndBrowse < ActiveRecord::Migration
  def change
    add_column :exhibits, :enable_search, :bool
    add_column :exhibits, :enable_browse, :bool
  end
end
