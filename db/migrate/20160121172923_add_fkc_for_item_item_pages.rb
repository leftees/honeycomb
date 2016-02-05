class AddFkcForItemItemPages < ActiveRecord::Migration
  def up
    add_foreign_key :items_pages, :items, column: :item_id
  end

  def down
    remove_foreign_key :items_pages, :items, column: :item_id
  end
end
