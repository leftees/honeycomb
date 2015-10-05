class AddHasSpacerToSection < ActiveRecord::Migration
  def change
    add_column :sections, :has_spacer, :booleanbe
  end
end
