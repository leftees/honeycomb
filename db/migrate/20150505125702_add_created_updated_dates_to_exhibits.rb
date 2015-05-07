class AddCreatedUpdatedDatesToExhibits < ActiveRecord::Migration
  def change
    unless column_exists? :exhibits, :created_at
      add_column(:exhibits, :created_at, :datetime)
    end
    unless column_exists? :exhibits, :updated_at
      add_column(:exhibits, :updated_at, :datetime)
    end

    Exhibit.find_each do |e|
      e.created_at = e.collection.created_at if e.created_at.nil?
      e.updated_at = e.collection.updated_at if e.updated_at.nil?
      e.save!
    end
  end
end
