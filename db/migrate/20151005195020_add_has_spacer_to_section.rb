class AddHasSpacerToSection < ActiveRecord::Migration
  def change
    add_column :sections, :has_spacer, :boolean
  end
end
