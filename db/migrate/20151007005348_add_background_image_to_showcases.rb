class AddBackgroundImageToShowcases < ActiveRecord::Migration
  def change
    add_attachment :showcases, :background_image
    add_attachment :showcases, :uploaded_background_image
  end
end
