class MigrateImagesToCollections < ActiveRecord::Migration
  class Exhibit < ActiveRecord::Base
  end

  def up # rubocop:disable Metrics/AbcSize
    add_column :collections, :image_file_name, :string
    add_column :collections, :image_content_type, :string
    add_column :collections, :image_file_size, :integer
    add_column :collections, :image_updated_at, :datetime
    add_column :collections, :uploaded_file_name, :string
    add_column :collections, :uploaded_image_content_type, :string
    add_column :collections, :uploaded_image_file_size, :integer
    add_column :collections, :uploaded_image_updated_at, :datetime
    Exhibit.find_each do |exhibit|
      file_name = exhibit.image_file_name
      content_type = exhibit.image_content_type
      file_size = exhibit.image_file_size
      updated_at = exhibit.image_updated_at.utc.to_s(:db)
      execute "UPDATE collections SET image_file_name = '#{file_name}', \
image_content_type = '#{content_type}', \
image_file_size = #{file_size}, \
image_updated_at = '#{updated_at}' WHERE id = #{exhibit.collection_id}" unless file_name.nil?
    end

    Exhibit.reset_column_information
    Collection.reset_column_information
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

    Exhibit.reset_column_information
    Collection.reset_column_information
  end
end
