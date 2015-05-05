class AddCreatedUpdatedDatesToExhibits < ActiveRecord::Migration
  def change
    add_column(:exhibits, :created_at, :datetime)
    add_column(:exhibits, :updated_at, :datetime)
    Exhibit.find_each do |e|
      e.created_at = e.collection.created_at
      e.updated_at = e.collection.updated_at
      e.save!
    end
  end
end
