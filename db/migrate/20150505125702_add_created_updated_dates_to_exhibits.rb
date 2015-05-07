class AddCreatedUpdatedDatesToExhibits < ActiveRecord::Migration
  def change
    add_column(:exhibits, :created_at, :datetime)
    add_column(:exhibits, :updated_at, :datetime)

    #Exhibit.find_each do |e|
    #  e.created_at = e.collection.created_at if e.created_at.nil?
    #  e.updated_at = e.collection.updated_at if e.updated_at.nil?
    #  e.save!
    #end
  end
end
