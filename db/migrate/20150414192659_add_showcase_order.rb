class AddShowcaseOrder < ActiveRecord::Migration
  def change
    add_column :showcases, :order, :integer
    add_index :showcases, :order
  end
end
