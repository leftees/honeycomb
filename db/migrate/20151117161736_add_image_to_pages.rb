class AddImageToPages < ActiveRecord::Migration
  def change
    add_column :pages, :image_id, :integer
    add_foreign_key :pages, :images
  end
end
