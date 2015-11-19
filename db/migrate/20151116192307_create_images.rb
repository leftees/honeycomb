class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :collection_id, null: false
      t.string :image_file_name, null: false
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.string :image_fingerprint, null: false
      t.text :image_meta
      t.timestamps null: false

      t.index :image_fingerprint
    end
  end
end
