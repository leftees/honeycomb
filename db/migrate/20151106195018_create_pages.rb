class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :unique_id
      t.string :name
      t.text :content
      t.integer :collection_id, null: false
      t.integer :image_id
      t.timestamps null: false
    end
    add_foreign_key :pages, :collections
  end
end
