class AddImagesToExhibits < ActiveRecord::Migration
  def change
    add_attachment :exhibits, :image
  end
end
