class AddTimestampsToSections < ActiveRecord::Migration
  def change
    add_column :sections, :updated_at, :datetime
    add_column :sections, :created_at, :datetime
  end
end
