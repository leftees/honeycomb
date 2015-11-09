class DropShowcaseOrder < ActiveRecord::Migration
  def change
    remove_column :showcases, :order, :integer
  end
end
