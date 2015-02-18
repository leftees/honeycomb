class CreateExhibits < ActiveRecord::Migration
  def change
    create_table :exhibits do |t|
      t.text :title
      t.text :description
      t.integer :collection_id
    end
  end
end
