class AddCreatedUpdatedDatesToExhibits < ActiveRecord::Migration
  def change
    add_column(:exhibits, :created_at, :datetime)
    add_column(:exhibits, :updated_at, :datetime)
  end
end
