class CreateShowcases < ActiveRecord::Migration
  def change
    create_table :showcases, force: true do |t|
      t.text :title
      t.text :description
      t.integer :exhibit_id
    end

    add_attachment :showcases, :image
  end
end
