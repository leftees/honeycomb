class AddImagesToCollections < ActiveRecord::Migration
  def up
    add_column :collections, :image_file_name, :string
    add_column :collections, :image_content_type, :string
    add_column :collections, :image_file_size, :integer
    add_column :collections, :image_updated_at, :datetime
    add_column :collections, :uploaded_image_file_name, :string
    add_column :collections, :uploaded_image_content_type, :string
    add_column :collections, :uploaded_image_file_size, :integer
    add_column :collections, :uploaded_image_updated_at, :datetime
  end

  def down
    remove_column :collections, :image_file_name
    remove_column :collections, :image_content_type
    remove_column :collections, :image_file_size
    remove_column :collections, :image_updated_at
    remove_column :collections, :uploaded_image_file_name
    remove_column :collections, :uploaded_image_content_type
    remove_column :collections, :uploaded_image_file_size
    remove_column :collections, :uploaded_image_updated_at
  end
end
