class AddSubtitleToShowcases < ActiveRecord::Migration
  def change
    add_column :showcases, :subtitle, :string
  end
end
